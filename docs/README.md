# publish-chart-circleci

This repo is an experiment that hosts helm charts and uses circleci to manage and deploy new ones to this local https server. The aim of this is to show that helm repo is just a server with an index file.

Guide:

Put some charts into the charts folder.

helm package chart -d charts