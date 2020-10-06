
# if [ -z "$GIT_REPO_NAME" ]
# then
#       echo "\$GIT_REPO_NAME is empty"
# else
#       echo "\$GIT_REPO_NAME is NOT empty"
# fi

# git clone https://github.com/sammcgeown/field-demo-dev-gitops.git repository

# cd repository

createYaml () {
    delete=0
    if [[ -f $1 ]] # If the file exists
    then
        echo "Processing $1"
    else
        prev_commit=$(git rev-parse HEAD^1)
        git checkout $prev_commit $1
        echo "Processing $1"
        delete=1
    fi

    kind=$(grep -m 1 "kind:" $1 | cut -d":" -f2 | awk '{$1=$1;print}')
    version=$(grep -m 1 "version:" $1 | cut -d":" -f2 | awk '{$1=$1;print}')
    package=$(grep -m 1 "package:" $1 | cut -d":" -f2 | awk '{$1=$1;print}')
    name=$(grep -m 1 "name:" $1 | cut -d":" -f2 | awk '{$1=$1;print}')


    if [[ delete -eq 1 ]]
    then
        cat $1 >> objects_to_delete.yaml
        echo "---" >> objects_to_delete.yaml
    else
        cat $1 >> objects_to_apply.yaml
        echo "---" >> objects_to_apply.yaml
    fi
}


LINES=$(git diff --name-only HEAD HEAD~1 | grep yaml)
while read line;
    do createYaml $line;
done <<<$LINES

# npm install yamljs

# cat >yaml.js <<EOL
# var fs = require('fs')
# var YAML = require('yamljs')

# var myArgs = process.argv.slice(2);
# var fileName = myArgs[0]

# const file = fs.readFileSync(fileName, 'utf8')
# var object = YAML.parse(file)
# console.log(YAML.stringify(object, 0, 0))
# EOL

# export CREATEYAML=$(node yaml.js objects_to_apply.yaml)
# export DELETEYAML=$(node yaml.js objects_to_delete.yaml)