# publish-chart-circleci

This repo is an experiment that hosts helm charts and uses circleci to manage and deploy new ones to this local https server. The aim of this is to show that helm repo is just a server with an index file.

Guide:

1. Set up the github page using a branch.

2. Put some charts into the charts folder.

```
helm package chart -d charts
```

3. Create an index file on the branch

```
helm repo index --url https://adamma-da.github.io/publish-chart-circleci . 
```
4. Add the helm repo, make sure you add the charts folder as that contains the index files and the charts themselves
```
Helm repo add myrepo https://adamma-da.github.io/publish-chart-circleci/charts
```
5. Test this setup by pulling a chart from the repo
```
helm pull myrepo/crossplane
```