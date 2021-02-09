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

discussions <- read.csv("gh_98_discussions.csv", header=TRUE, sep=",", quote="\"", strip.white=TRUE, encoding="UTF-8", na.strings=c("", "null"), stringsAsFactors=FALSE)
n_dis <- nrow(discussions)
n_dis
# 9240

posts <- read.csv("gh_98_discussion_posts.csv", header=TRUE, sep=",", quote="\"", strip.white=TRUE, encoding="UTF-8", na.strings=c("", "null"), stringsAsFactors=FALSE)
n_pos <- nrow(posts)
n_pos
# 37407

posts_sent <- read.csv("gh_98_discussion_posts_sentimentAnnotation.csv", header=TRUE, sep=",", quote="\"", strip.white=TRUE, encoding="UTF-8", na.strings=c("", "null"), stringsAsFactors=FALSE)
n_pos_sent <- nrow(posts_sent)
n_pos_sent
# 37397

posts_tox <- read.csv("gh_98_discussion_posts_toxicity_scores.csv", header=TRUE, sep=",", quote="\"", strip.white=TRUE, encoding="UTF-8", na.strings=c("", "null"), stringsAsFactors=FALSE)
n_posts_tox <- nrow(posts_tox)
n_posts_tox
# 37397

# number of repos
repos_dis <- unique(discussions$repo_name)
length(repos_dis)
# 98
repos_pos <- unique(posts$repo_name)
length(repos_pos)
# 96
repos_pos_sent <- unique(posts_sent$repo_name)
length(repos_pos_sent)
# 96
repos_pos_tox <- unique(posts_tox$repo_name)
length(repos_pos_tox)
# 96

setdiff(repos_dis, repos_pos)
# [1] "dotnet/winforms" "npm/cli" 
# Sebastian: In those repos, the Discussion feature was activated, but no discussion posts present when I collected the data

# number of discussions
discussions_dis <- unique(discussions$discussion)
length(discussions_dis)
# 9236 (difference to number of rows is number of repos without discussions)
discussions_pos <- unique(posts$discussion)
length(discussions_pos)
# 9234

setdiff(discussions_dis, discussions_pos)
# [1] "https://github.com/strapi/strapi/discussions/5094"
# [2] "n/a"
# Sebastian: "n/a" marks repos without discussions, the other discussions yields an error on GitHub:
# "Something went wrong: Not all the comments could be copied from the original issue to the new discussion."

# ignore those discussions
discussions <- discussions[discussions$discussion %in% discussions_pos,]
n_dis <- nrow(discussions)
n_dis
# 9237
setdiff(unique(discussions$discussion), unique(posts$discussion))
# character(0)

discussions <- discussions[!duplicated(discussions$discussion),]
write.table(discussions, file="gh_98_discussions.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

posts <- posts[!duplicated(posts),]
write.table(posts, file="gh_98_discussion_posts.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

posts_sent <- posts_sent[!duplicated(posts_sent),]
write.table(posts_sent, file="gh_98_discussion_posts_sentimentAnnotation.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

posts_tox <- posts_tox[!duplicated(posts_tox),]
write.table(posts_tox, file="gh_98_discussion_posts_toxicity_scores.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

# merge data
posts_ex <- merge(posts, discussions[,c("discussion", "converted_from_issue")], by=c("discussion"), all.x=TRUE)
# reorder columns (otherwise discussion is first column)
posts_ex <- posts_ex[,c(names(posts), "converted_from_issue")]
n_pos_ex <- nrow(posts_ex)
n_pos_ex
# 37397

table(discussions$converted_from_issue)
# False  True 
# 8035  1199 

table(posts_ex$converted_from_issue)
# False  True 
# 26829  5885 

# write posts with additional flag "converted_from_issue"
write.table(posts_ex, file="gh_98_discussion_posts_ex.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")
#write.table(posts_sent, file="gh_98_discussion_posts_sentimentAnnotation.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

# analyze distributions of discussions per repo
discussion_count <- sqldf("SELECT repo_name, COUNT(discussion) AS discussion_count FROM posts_ex GROUP BY repo_name ORDER BY discussion_count DESC")

# write frequency data
write.table(discussion_count, file="gh_98_discussion_count_per_repo.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

# filter data (only before 2020-08-01)
discussions$timestamp <- as.POSIXct(discussions$timestamp, tz="UTC")
discussions <- discussions[difftime(as.POSIXct("2020-08-01 UTC"), discussions$timestamp, tz="UTC", units="days") > 0,]
nrow(discussions)
# 7,983
write.table(discussions, file="gh_98_discussions_filtered.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

posts$timestamp <- as.POSIXct(posts$timestamp, tz="UTC")
posts <- posts[difftime(as.POSIXct("2020-08-01 UTC"), posts$timestamp, tz="UTC", units="days") > 0,]
nrow(posts)
# 32,714
write.table(posts, file="gh_98_discussion_posts_filtered.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

posts_ex$timestamp <- as.POSIXct(posts_ex$timestamp, tz="UTC")
posts_ex <- posts_ex[difftime(as.POSIXct("2020-08-01 UTC"), posts_ex$timestamp, tz="UTC", units="days") > 0,]
nrow(posts_ex)
# 32,714
write.table(posts_ex, file="gh_98_discussion_posts_ex_filtered.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

write.table(posts_ex[,c(1:6, 8)], file="gh_98_discussion_posts_ex_filtered_no_content.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

posts_sent$timestamp <- as.POSIXct(posts_sent$timestamp, tz="UTC")
posts_sent <- posts_sent[difftime(as.POSIXct("2020-08-01 UTC"), posts_sent$timestamp, tz="UTC", units="days") > 0,]
nrow(posts_sent)
# 32,714
write.table(posts_sent, file="gh_98_discussion_posts_sentimentAnnotation_filtered.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

posts_tox$timestamp <- as.POSIXct(posts_tox$timestamp, tz="UTC")
posts_tox <- posts_tox[difftime(as.POSIXct("2020-08-01 UTC"), posts_tox$timestamp, tz="UTC", units="days") > 0,]
nrow(posts_tox)
# 32,714 
write.table(posts_tox, file="gh_98_discussion_posts_toxicity_scores_filtered.csv", sep=",", col.names=TRUE, row.names=FALSE, na="", quote=TRUE, qmethod="double", fileEncoding="UTF-8")

table(discussions$converted_from_issue)
# False  True 
#  6879  1104

table(posts_ex$converted_from_issue)
# False  True 
# 26829  5885 

