#!/bin/bash

set -x

# Set up script variables
CHARTS_DIR=../charts
HELMREPO_NAME=myrepo
PUBLISH_BRANCH=publish
GITREPO_NAME=publish-chart-circleci
GITREPO_OWNER=adamma-da

# Loop through the helm charts in the designated folder
for chart in $CHARTS_DIR/*; do
    if [ "$chart" == "$CHARTS_DIR/index.yaml" ]; then
        # If it is, skip over this iteration of the loop
        continue
    fi

    # Get the chart name and version from the Chart.yaml file and load them into vars
    chart_name=$(yq eval '.name' $chart/Chart.yaml)
    chart_version=$(yq eval '.version' $chart/Chart.yaml)

    # Check if the chart version has already been pushed to the repo
    if helm search repo $HELMREPO_NAME/$chart_name -o yaml | grep --silent -w "version: $chart_version"; then
        echo "Chart $chart_name version $chart_version already exists in repository $HELMREPO_NAME"
    else
        # Handling the version incremented chart
        helm package $chart -d ../.cr-release-packages
        cr upload -c $PUBLISH_BRANCH -r $GITREPO_NAME -p ../.cr-release-packages --owner $GITREPO_OWNER --token $1 | true
        # helm push $CHARTS_DIR/$chart_name-$chart_version.tgz $HELMREPO_NAME
        echo "Chart $chart_name version $chart_version has been pushed to repository $HELMREPO_NAME"
        # rm ../.cr-release-packages/$chart_name-$chart_version.tgz
    fi
done
cr index -r $GITREPO_NAME -i ../charts/ --pages-branch publish -p ../.cr-release-packages --owner $GITREPO_OWNER --token $1




 