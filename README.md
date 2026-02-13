# hazard.github.io

Simple GitHub Pages Maven repository.

## 1) Enable GitHub Pages

In this repo:

1. Open **Settings** → **Pages**.
2. Set **Source** to `Deploy from a branch`.
3. Choose `main` branch and `/ (root)` folder.

Your repository URL will be:

- `https://hazard.github.io/maven/`

If you fork/rename, replace `hazard` with your GitHub username.

## 2) Add artifacts

Deploy artifacts into the local `maven/` folder, then commit and push.

Example:

```bash
mvn deploy:deploy-file \
  -DgroupId=com.example \
  -DartifactId=my-lib \
  -Dversion=1.0.0 \
  -Dpackaging=jar \
  -Dfile=build/libs/my-lib-1.0.0.jar \
  -Durl=file:$(pwd)/maven \
  -DrepositoryId=local-github-pages
```

Then:

```bash
./scripts/generate-indexes.sh
git add maven
git commit -m "Add my-lib 1.0.0"
git push
```

## 3) Use from Maven/Gradle

Maven:

```xml
<repositories>
  <repository>
    <id>hazard-github</id>
    <url>https://hazard.github.io/maven/</url>
  </repository>
</repositories>
```

Gradle:

```kotlin
repositories {
  maven("https://hazard.github.io/maven/")
}
```

## 4) Auto-indexing

On push, GitHub Actions runs `scripts/generate-indexes.sh` and commits updated `index.html` files in `maven/`.
