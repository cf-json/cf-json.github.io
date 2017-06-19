jekyll build -s ./docs-theme -c _config.yml
cp -R docs-theme/_includes .
cp -R docs-theme/_layouts .
git add .
git commit -m 'Rebuilding docs' 
git push
