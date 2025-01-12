---
title: "Page"
author: "Niels"
date: "2024-06-11"
---

# Page: on the creation of a simple website generator

Here I will detail how this website is hosted.
Key for me is simplicity, as such this website is:

* Completely static.
* Written entirely in markdown.
* Hosted on github, automatically deploying using actions.

You can inspect the repository of this website [here](https://github.com/nielsdekoeijer/page).

## How does it work?
* The website project structure is given as follows:

    ```text
    ├── Makefile
    ├── content
    │   ├── about.md
    │   ├── contact.md
    │   ├── projects
    │   │   ├── mnist-web
    │   │   └── page
    │   ├── projects.md
    │   └── work.md
    ├── pandoc
    │   ├── defaults.yml
    │   ├── footer.html
    │   ├── header.html
    │   └── template.html
    └── serve.py
    ```

* To deploy changes, we simply change the contents of the `content` directory.

* Then, when we push these changes, 
    github-actions runs the [Makefile](https://github.com/nielsdekoeijer/page/blob/main/Makefile).
    This Makefile uses pandoc to convert the markdown files to HTML. 
    I do this such that the directory structure of the content folder is preserved. 
    This simplifies the reasoning required when linking between pages in the website.

* In order to "style" the website, 
    we use the pandoc HTML templating feature to define the CSS, header, and footer of the website.
