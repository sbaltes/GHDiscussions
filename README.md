# Research Artifact: An Exploratory Study of GitHub Discussions Early Adoption

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5026134.svg)](https://doi.org/10.5281/zenodo.5026134)

This is a research artifact for the study **GitHub Discussions: An Exploratory Study of Early Adoption**. The following research questions were constructed to guide the study.

- RQ1: *How have GitHub Discussions been adopted?*
  - RQ1.1: *What are GitHub Discussions about?*
  - RQ1.2: *Who contributes to GitHub Discussions?*
  - RQ1.3: *What is the relationship between project characteristics and GitHub Discussion adoption?*

- RQ2: *What are developer perceptions of GitHub Discussions?*
  - RQ2.1: *Why do projects adopt GitHub Discussions?*
  - RQ2.2: *How do developers perceive GitHub Discussions?*

- RQ3: *How do GitHub Discussions relate and compare to other communication channels?*
  - RQ3.1: *What is the impact of GitHub Discussions on other channels?*
  - RQ3.2: *What are content differences compared to Stack Overflow posts?*

The datasets only contain metadata, we removed all post contents due to potential licensing and copyright issues.

## Dataset

* [ranked repositories](gh-repos/gh-repos-ranking.csv)
* [repository features](gh-repos/gh-repos-features.csv)
* [analyzed repositories](gh-repos/gh-repos.csv)
* [number of discussions per analyzed repository](gh-discussions/discussion-count-per-repo.csv)
* [analyzed discussion threads](gh-discussions/discussions.csv)
* [analyzed discussion posts](gh-discussions/discussion-posts.csv)

To retrieve the top 10,000 GitHub projects ranked by their number of stargazers, we utilized a [tool](https://github.com/sbaltes/api-retriever/tree/v0.3.0#retrieving-top-rated-github-repositories-according-to-stars) that one of our co-authors developed. The version used for this paper is also archived on [Zenodo](https://doi.org/10.5281/zenodo.4464050).

Due to GitHub's API limitations, we had to retrieve the repositories in multiple iterations and merge the results.
The file [gh-repos-ranking.csv](gh-repos/gh-repos-ranking.csv) contains all 10,899 repositories we retrieved along with metadata.

Since information about Discussions was not available via GitHub's API, we developed another [tool](https://github.com/sbaltes/github-retriever/) to retrieve the features activated for those 10,899 repositories (also archived on [Zenodo](https://doi.org/10.5281/zenodo.3908648)). Retrieved features included Pull Requests, Issues, and of course also Discussions. The retrieved information is available in file [gh-repo-features.csv](gh-repos/gh-repos-features.csv).

Of those 10,899 repositories, 99 had the Discussions feature activated.
We again used our [tool](https://github.com/sbaltes/github-retriever/), this time to retrieve the discussion posts from those 99 repositories.
After merging the retrieved data (see [merge_data.R](data/merge_data.R)), removing projects without any discussion posts, and removing one non-software project, we had our final dataset containing metadata and Discussions of 92 GitHub projects.
All discussion posts we included in our analysis can be found in file [discussion-posts.csv](gh-discussions/discussion-posts.csv).

## Processed data

### RQ1.1 Discussion Categories

* [coding results for discussions from issues](RQ1.1_discussions_from_issues.csv)
* [coding results for discussions not from issues](RQ1.1_discussions_not_from_issues.csv)

coding guide
- *Errors* - Discussions of this category contain exceptions and stack traces and ask for help in fixing errors or understanding what the exceptions mean.
- *Discrepancy* - Discussions containing questions about problems or unexpected behavior where the questioners have no clue how to solve them.
- *Review* - Discussions of this category contain code snippets and ask for better solutions, help to make decisions, or to review their code snippets.
- *Conceptual* - These discussions mainly ask high-level questions, such as the limitations of functionalities, underlying concepts (design patterns, architectural styles, etc.), and background information.
- *Usage* - Discussions of this category contain questions asking for concrete instructions of specific functionalities.
- *Learning* - In these discussions, the questioners ask for documentation or tutorials to learn the software of the projects. Instead of asking for solutions or instructions on how to do something, they aim at asking for resources of documentation, tutorials, or examples, to learn on their own.
- *Versions* - Discussions in this category are not limited to API changes but are related to any questions that arise because of different versions of the software or environmental settings.
- *Plans* - Discussions of this category ask for future plans of software releases or development processes.
- *Announcement* - These discussions are used for announcements about specific events of the software (e.g., future updates, releases).
- *Information* - Discussions in this category provide general information, which is not related to events of the software.
- *Recruitment* - These discussions indicate offers of job vacancies or recruiting contributors to the teams.
- *Other* - Discussions that do not fit the above categories.
- *404* - Discussions which had been removed when we accessed them.

### RQ1.3 Project Characteristics

* [coding results and project statistics](RQ1.3_repos_to_check.csv)

coding guide
- *Web libraries and frameworks* - Software for web development.
- *Software tools* - Systems that support software development tasks, like IDEs, package managers, and compilers.
- *Application software* - Systems that provide functionalities to end-users, like browsers and text editors.
- *Non-web libraries and frameworks* - Frameworks not intended for web development.
- *System software* - Systems that provide services and infrastructure to other systems, like operating systems, middleware, servers, and databases.

### RQ2.1 Initial Discussions

* [coding results](RQ2.1_initial_discussions.csv)

coding guide
- *Question-answering* - Several projects indicated that the Discussion feature could be used for asking and answering questions, e.g., "I'm trying out GitHub Discussions in the hopes that folks will be encouraged to both ask questions and give answers. Remember, there are no stupid questions!"
- *Idea sharing* - Sharing of ideas was also mentioned by several projects, although few projects provided details of how such sharing could be structured.
- *Community engagement* - Projects also mentioned using GitHub Discussions to engage with their broader community, e.g., "We want to try using GitHub's new discussion feature to structure conversations that may not quite be an Issue, but would benefit from community involvement and searchability."
- *Decluttering issue tracker* - A few projects explicitly mentioned the relationship between GitHub Discussions and GitHub Issues, suggesting that Discussions could help declutter the issue tracker, e.g., "Unsure whether what you're experiencing is a bug or not? Post it here first! if it is indeed a bug, moving it to Issues once it's confirmed is an easy task."
- *Information resource building* - Projects also mentioned using Discussions as a way of building an information resource, which is in line with GitHub's original intent behind the Discussions feature.
- *Feature requests* -  Discussing new features was also mentioned as a use case of GitHub Discussions.
- *Thank-you* - In one case, the first discussion thread was used to say thank-you to everyone involved in the project.
- *Testing the feature* - Several development teams used their first GitHub Discussion to test the new functionality, in particular threaded replies.
- *Not meta* - We used this code to indicate cases where the first Discussion thread had not been used to discuss the feature itself.

### RQ2.2 Online Survey

We provide the questionnaire we used for our online survey [here](RQ2.2_survey_questionnaire.pdf).

### RQ3.1 Impact on Other Channels

* [coding results](RQ3.1_links_in_discussions.csv)

coding guide
- *Newly open* - An Issue or Pull Request was opened as a result of a GitHub Discussion.
- *Deepen discussion* - In some cases, GitHub Discussions were used to deepen the discussions related to an Issue or Pull Request, in many cases exploring the broader implications of these artefacts.
- *Reference* - In other cases, the Discussion thread did not directly affect an Issue or Pull Request, but referenced it for traceability purposes.

### RQ3.2 Content Differences Compared to Stack Overflow Posts

* [GitHub discussion posts (sentiment)](RQ3.2_gh_discussion_posts_sentiment.csv)
* [GitHub discussion posts (toxicity)](RQ3.2_gh_discussion_posts_toxicity.csv)
* [Stack Overflow posts (sentiment)](RQ3.2_so_posts_sentiment.csv)
* [Stack Overflow posts (toxicity)](RQ3.2_so_posts_toxicity.csv)

We provde the output of sentiment and toxicity analysis for both GitHub Discussion posts and Stack Overflow posts. 
The author information and post content are not included, as outlined above.

## Authors
- [Hideaki Hata](https://hideakihata.github.io/)
- [Nicole Novielli](http://collab.di.uniba.it/nicole/)
- [Sebastian Baltes](https://empirical-software.engineering/)
- [Raula Gaikovina Kula](https://raux.github.io/)
- [Christoph Treude](http://ctreude.ca/)
