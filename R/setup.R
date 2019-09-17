setup_project <- function(path, ...) {
    # ensure path exists
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
    dots <- list(...)
    # generate Rprofile for project with fixed MRAN
    rprofile_contents <- glue::glue(
        "\n",
        "#### -- setting up Repos",
        "# We explicitly set the MRAN snapshot to make sure code created by different",
        "# analysts is reproducible. This was no unexpected package updates cause problems",
        "# when an analysis is rerun at a later date. You can manually update this, but",
        "# be sure you understand the consequence before doing so.",
        "local({{",
        "r <- getOption(\"repos\")",
        "r[\"CRAN\"] <- \"http://mran.revolutionanalytics.com/snapshot/{snapshot}\"",
        "options(repos = r)",
        "}})",
        "message(\"Project will search for packages in MRAN snapshot from {snapshot} and WTWRAN.\nTo update see project .Rprofile\")",
        .envir = dots, .sep = "\n", .open = "{", .close = "}" )

    message("Setting up git repo")
    git2r::init(path)
    git_ignore <- c(".Rproj.user",
                    ".Rhistory",
                    ".Rdata",
                    ".Ruserdata")
    writeLines(git_ignore, file.path(path, ".gitignore"))

    packrat::init(path, restart = FALSE)
    install.packages(c("tidyverse", "lubridate", "jsonlite", "httr"),
                     dependencies = "Imports",
                     type = "win.binary")

    message("Setting up CRAN repos")
    setwd("..")
    on.exit(getOption("restart")())
    cat(rprofile_contents, file = file.path(path, ".Rprofile"), append = TRUE)


}
