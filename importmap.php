<?php

/**
 * Returns the importmap for this application.
 *
 * - If "path" starts with "./", it's local to the project (served from /assets/).
 * - "version" entries are downloaded from a CDN on first use (run `php bin/console importmap:install`).
 * - Add new packages: php bin/console importmap:require <package>
 */
return [
    'app' => [
        'path' => './assets/app.js',
        'entrypoint' => true,
    ],
    '@hotwired/stimulus' => [
        'version' => '3.2.2',
    ],
    '@symfony/stimulus-bundle' => [
        'path' => './vendor/symfony/stimulus-bundle/assets/dist/loader.js',
    ],
    '@hotwired/turbo' => [
        'version' => '7.3.0',
    ],
];
