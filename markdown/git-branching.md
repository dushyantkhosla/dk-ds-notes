Create a branch

```bash
# List local branches
git branch --list

# List branches remote
git branch -a

# Create
git branch BRANCH-NAME

# Switch to the branch
git checkout BRANCH-NAME

# Create a new branch and switch to it
git checkout -b NEW-BRANCH

# Check if you're on the right branch
git status

# *** Make changes ***

# Add 
git add CHANGED-FILE(S)

# Commit
git commit -m "Message"

# --- 1. Push branch to origin ---
git push origin BRANCH-NAME

# --- 2. Integrate branch to Master locally, push to Origin ----

# Switch to Master
git checkout master

# Merge
git merge BRANCH-NAME

# Delete the branch
git branch -d BRANCH-NAME
# Force Delete
git branch -D BRANCH-NAME

# Push to Origin
git push origin master
```



