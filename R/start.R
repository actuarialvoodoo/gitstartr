create_share_repo <- function(path) {
    # check if path exists
    # create path if it doesn't
    # error if cannot create
    git2r::init(path, bare = TRUE)
}

add_share_repo <- function(url, repo = ".", remote_name = "origin", pull = FALSE) {
    # check if path exists and is a git repo
    # check if remote_name already exists (error if it exists)
    git2r::remote_add(repo = repo, name = remote_name, url = url)
}
