import 'dart:io';

import 'package:static_shock/static_shock.dart';

Future<void> main(List<String> arguments) async {
  // Configure the static website generator.
  final staticShock = StaticShock()
    // Pick source files.
    ..pick(DirectoryPicker.parse("images"))
    ..pickRemote(
      layouts: _remoteLayouts,
      components: _remoteComponents,
      assets: _remoteAssets,
    )
    // Add all needed plugins.
    ..plugin(const MarkdownPlugin())
    ..plugin(const JinjaPlugin())
    ..plugin(const PrettyUrlsPlugin())
    ..plugin(const RedirectsPlugin())
    ..plugin(const SassPlugin())
    ..plugin(DraftingPlugin(
      showDrafts: arguments.contains("preview"),
    ))
    ..plugin(const PubPackagePlugin({
      "ffmpeg_cli",
    }))
    ..plugin(
      GitHubContributorsPlugin(
        authToken: Platform.environment["github_doc_website_token"],
      ),
    );

  // Generate the static website.
  await staticShock.generateSite();
}

final _remoteLayouts = <RemoteIncludeSource>{
  // Main page layout.
  RemoteInclude(
    url:
        "https://raw.githubusercontent.com/Flutter-Bounty-Hunters/fbh_branding/main/single-page-doc-sites/_includes/layouts/homepage.jinja?raw=true",
    name: "homepage",
  ),
};

final _remoteComponents = <RemoteIncludeSource>{
  // Contributors component (used by main page layout).
  RemoteInclude(
    url:
        "https://raw.githubusercontent.com/Flutter-Bounty-Hunters/fbh_branding/main/single-page-doc-sites/_includes/components/contributors.jinja?raw=true",
    name: "contributors",
  ),
};

final _remoteAssets = <RemoteFileSource>{
  // Sass styles.
  HttpFileGroup.fromUrlTemplate(
    "https://raw.githubusercontent.com/Flutter-Bounty-Hunters/fbh_branding/main/single-page-doc-sites/styles/\$",
    buildDirectory: "styles/",
    files: {
      "theme.scss",
      "homepage.scss",
    },
  ),

  // Flutter and Dart logos.
  RemoteFile(
    url:
        "https://raw.githubusercontent.com/Flutter-Bounty-Hunters/fbh_branding/main/single-page-doc-sites/images/google/dart-logo.svg?raw=true",
    buildPath: FileRelativePath("images/branding/", "dart-logo", "svg"),
  ),
  RemoteFile(
    url:
        "https://raw.githubusercontent.com/Flutter-Bounty-Hunters/fbh_branding/main/single-page-doc-sites/images/google/flutter-logo.svg?raw=true",
    buildPath: FileRelativePath("images/branding/", "flutter-logo", "svg"),
  ),

  // Dart Favicons.
  HttpFileGroup.fromUrlTemplate(
    "https://github.com/Flutter-Bounty-Hunters/fbh_branding/blob/main/single-page-doc-sites/images/google/dart-favicon/\$?raw=true",
    buildDirectory: "images/favicon/dart/",
    files: {
      "android-chrome-192x192.png",
      "android-chrome-512x512.png",
      "apple-touch-icon.png",
      "browserconfig.xml",
      "favicon-16x16.png",
      "favicon-32x32.png",
      "favicon.ico",
      "mstile-150x150.png",
      "site.webmanifest",
    },
  ),

  // Flutter Favicons.
  HttpFileGroup.fromUrlTemplate(
    "https://github.com/Flutter-Bounty-Hunters/fbh_branding/blob/main/single-page-doc-sites/images/google/flutter-favicon/\$?raw=true",
    buildDirectory: "images/favicon/flutter/",
    files: {
      "android-chrome-192x192.png",
      "android-chrome-512x512.png",
      "apple-touch-icon.png",
      "browserconfig.xml",
      "favicon-16x16.png",
      "favicon-32x32.png",
      "favicon.ico",
      "mstile-150x150.png",
      "safari-pinned-tab.svg",
      "site.webmanifest",
    },
  ),
};
