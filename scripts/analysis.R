# set working directory (see https://stackoverflow.com/a/35842119)
dir = tryCatch({
  # script being sourced
  getSrcDirectory()[1]
}, error = function(e) {
  # script being run in RStudio
  dirname(rstudioapi::getActiveDocumentContext()$path)
})
setwd(dir)

library(sqldf)

################################################################################

repos <- read.csv("gh_repo_features.csv", header=TRUE, sep=",", quote="\"", strip.white=TRUE, encoding="UTF-8", na.strings=c("", "null"), stringsAsFactors=FALSE)
nrow(repos)
# 10,899

repos$has_code <- as.logical(repos$has_code)
length(which(repos$has_code))
# 10,896

repos$has_issues <- as.logical(repos$has_issues)
length(which(repos$has_issues))
# 10,432

repos$has_pull_requests <- as.logical(repos$has_pull_requests)
length(which(repos$has_pull_requests))
# 10,896

repos$has_discussions <- as.logical(repos$has_discussions)
length(which(repos$has_discussions))
# 99

repos$has_actions <- as.logical(repos$has_actions)
length(which(repos$has_actions))
# 10,744

repos$has_projects <- as.logical(repos$has_projects)
length(which(repos$has_projects))
# 8,997

repos$has_wiki <- as.logical(repos$has_wiki)
length(which(repos$has_wiki))
# 4,071
