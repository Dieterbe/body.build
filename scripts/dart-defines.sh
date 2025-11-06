#!/bin/bash

# Note: in CI (codemagic) we don't include --dirty, because:
# 1) codemagic makes various changes to all kinds of ios/macos related files, "dirtying" the repo.
#    and not sure if the exact changes will remain consistent over time (probably not)
# 2) if we gitignore even just the files known to be modified by codemagic today, gitignore only ignores 'new' files,
#    and i suspect those files need to be in the repo in some shape (therefore, gitignore doesn't apply to them)
# 3) locally we want to mark the '-dirty' suffix as we can accidentally include dirty changes,
#    but codemagic always builds from what's in git anyway

version=$(./scripts/version.sh)
if [ "$1" == "ci" ]; then
  version=${version%-dirty}
fi

yt_android=
yt_ios=
yt_web=
yt_linux=
if [ -r "secret/youtube-api-key-web" ]; then
  yt_web=",\"YOUTUBE_API_KEY\":\"$(cat secret/youtube-api-key-web)\""
fi
if [ -r "secret/youtube-api-key-android" ]; then
  yt_android=",\"YOUTUBE_API_KEY\":\"$(cat secret/youtube-api-key-android)\""
fi
if [ -r "secret/youtube-api-key-ios" ]; then
  yt_ios=",\"YOUTUBE_API_KEY\":\"$(cat secret/youtube-api-key-ios)\""
fi
if [ -r "secret/youtube-api-key-linux" ]; then
  yt_linux=",\"YOUTUBE_API_KEY\":\"$(cat secret/youtube-api-key-linux)\""
fi

cat >.vscode/dart-defines-android.json <<EOF
{"APP_VERSION":"$version","APP_BUILD_TIME":"$(date)"$yt_android}
EOF

cat >.vscode/dart-defines-ios.json <<EOF
{"APP_VERSION":"$version","APP_BUILD_TIME":"$(date)"$yt_ios}
EOF

cat >.vscode/dart-defines-web.json <<EOF
{"APP_VERSION":"$version","APP_BUILD_TIME":"$(date)"$yt_web}
EOF

cat >.vscode/dart-defines-linux.json <<EOF
{"APP_VERSION":"$version","APP_BUILD_TIME":"$(date)"$yt_linux}
EOF
