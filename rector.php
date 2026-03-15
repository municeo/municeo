<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;
use Rector\PHPUnit\Set\PHPUnitSetList;
use Rector\Set\ValueObject\LevelSetList;
use Rector\Set\ValueObject\SetList;

return RectorConfig::configure()
    ->withPaths([
        __DIR__ . '/src',
        __DIR__ . '/tests',
    ])
    ->withSkip([
        // Domain layer: pure PHP — no framework-specific rector rules apply here
        __DIR__ . '/src/Domain',
        // Generated / third-party directories
        __DIR__ . '/var',
        __DIR__ . '/vendor',
    ])
    ->withSets([
        // PHP version upgrade path (update to UP_TO_PHP_85 when available)
        LevelSetList::UP_TO_PHP_84,

        // Code quality sets
        SetList::DEAD_CODE,
        SetList::TYPE_DECLARATION,
        SetList::STRICT_BOOLEANS,
        SetList::CODE_QUALITY,

        // PHPUnit modernisation
        PHPUnitSetList::PHPUNIT_110,
    ])
    ->withPhpSets(php85: true)
    ->withAttributesSets(
        symfony: true,
        doctrine: true,
    );
