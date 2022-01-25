FROM golang:1.17.5 as builder
RUN GO111MODULE=on go get -u -ldflags="-s -w" github.com/paketo-buildpacks/libpak/cmd/update-buildpack-dependency

FROM alpine:3.11.3
COPY --from=builder /build/golang-memtest . 

FROM ubuntu:20.04

COPY --from=builder /go/bin/update-buildpack-dependency /usr/local/bin

#- name: Install yj
#  run: |

#    set -euo pipefail

#    echo "Installing yj ${YJ_VERSION}"

#    mkdir -p "${HOME}"/bin
#    echo "${HOME}/bin" >> "${GITHUB_PATH}"

#    curl \
#      --location \
#      --show-error \
#      --silent \
#      --output "${HOME}"/bin/yj \
#      "https://github.com/sclevine/yj/releases/download/v${YJ_VERSION}/yj-linux"

#    chmod +x "${HOME}"/bin/yj
#  env:
#    YJ_VERSION: 5.0.0
#- uses: actions/checkout@v2
#- id: dependency
#  uses: docker://ghcr.io/paketo-buildpacks/actions/maven-dependency:main
#  with:
#    artifact_id: postgresql
#    group_id: org.postgresql
#    uri: https://repo1.maven.org/maven2
#- name: Update Buildpack Dependency
#  id: buildpack
#  run: |-
#    #!/usr/bin/env bash

#    set -euo pipefail

#    OLD_VERSION=$(yj -tj < buildpack.toml | jq -r "
#      .metadata.dependencies[] |
#      select( .id == env.ID ) |
#      select( .version | test( env.VERSION_PATTERN ) ) |
#      .version")

#    update-buildpack-dependency \
#      --buildpack-toml buildpack.toml \
#      --id "${ID}" \
#      --version-pattern "${VERSION_PATTERN}" \
#      --version "${VERSION}" \
#      --cpe-pattern "${CPE_PATTERN:-}" \
#      --cpe "${CPE:-}" \
#      --purl-pattern "${PURL_PATTERN:-}" \
#      --purl "${PURL:-}" \
#      --uri "${URI}" \
#      --sha256 "${SHA256}"

#    git add buildpack.toml
#    git checkout -- .

#    if [ "$(echo "$OLD_VERSION" | awk -F '.' '{print $1}')" != "$(echo "$VERSION" | awk -F '.' '{print $1}')" ]; then
#      LABEL="semver:major"
#    elif [ "$(echo "$OLD_VERSION" | awk -F '.' '{print $2}')" != "$(echo "$VERSION" | awk -F '.' '{print $2}')" ]; then
#      LABEL="semver:minor"
#    else
#      LABEL="semver:patch"
#    fi

#    echo "::set-output name=old-version::${OLD_VERSION}"
#    echo "::set-output name=new-version::${VERSION}"
#    echo "::set-output name=version-label::${LABEL}"
#  env:
#    CPE: ${{ steps.dependency.outputs.cpe }}
#    CPE_PATTERN: ""
#    ID: postgres-driver
#    PURL: ${{ steps.dependency.outputs.purl }}
#    PURL_PATTERN: ""
#    SHA256: ${{ steps.dependency.outputs.sha256 }}
#    URI: ${{ steps.dependency.outputs.uri }}
#    VERSION: ${{ steps.dependency.outputs.version }}
#    VERSION_PATTERN: '[\d]+\.[\d]+\.[\d]+'
#- uses: peter-evans/create-pull-request@v3
#  with:
#    author: ${{ secrets.JAVA_GITHUB_USERNAME }} <${{ secrets.JAVA_GITHUB_USERNAME }}@users.noreply.github.com>
#    body: Bumps `postgres-driver` from `${{ steps.buildpack.outputs.old-version }}` to `${{ steps.buildpack.outputs.new-version }}`.
#    branch: update/buildpack/postgres-driver
#    commit-message: |-
#        Bump postgres-driver from ${{ steps.buildpack.outputs.old-version }} to ${{ steps.buildpack.outputs.new-version }}

#        Bumps postgres-driver from ${{ steps.buildpack.outputs.old-version }} to ${{ steps.buildpack.outputs.new-version }}.
#    delete-branch: true
#    labels: ${{ steps.buildpack.outputs.version-label }}, type:dependency-upgrade
#    signoff: true
#    title: Bump postgres-driver from ${{ steps.buildpack.outputs.old-version }} to ${{ steps.buildpack.outputs.new-version }}
#    token: ${{ secrets.JAVA_GITHUB_TOKEN }}
