<?php

declare(strict_types=1);

use PhpCsFixer\Config;
use PhpCsFixer\Finder;

$finder = Finder::create()
    ->in([
        __DIR__ . '/src',
        __DIR__ . '/tests',
    ])
    ->name('*.php')
    ->notPath('var')
    ->notPath('vendor');

return (new Config())
    ->setRiskyAllowed(true)
    ->setRules([
        // Base rule sets
        '@Symfony'        => true,
        '@Symfony:risky'  => true,

        // PHP 8.x migration (latest available; update to @PHP85Migration when released)
        '@PHP84Migration'        => true,
        '@PHP84Migration:risky'  => true,

        // PHPUnit migration
        '@PHPUnit100Migration:risky' => true,

        // Strict mode — every file must declare strict_types=1
        'declare_strict_types' => true,

        // Imports
        'ordered_imports'              => ['sort_algorithm' => 'alpha'],
        'no_unused_imports'            => true,
        'fully_qualified_strict_types' => true,
        'global_namespace_import'      => [
            'import_classes'   => true,
            'import_functions' => false,
            'import_constants' => false,
        ],

        // Modern PHP idioms
        'modernize_types_casting'       => true,
        'no_useless_nullsafe_operator'  => true,
        'nullable_type_declaration_for_default_null_value' => true,

        // Doc blocks
        'no_superfluous_phpdoc_tags' => ['remove_inheritdoc' => true, 'allow_mixed' => true],

        // Misc
        'strict_param'             => true,
        'array_syntax'             => ['syntax' => 'short'],
        'concat_space'             => ['spacing' => 'one'],
        'trailing_comma_in_multiline' => ['elements' => ['arrays', 'arguments', 'parameters', 'match']],
    ])
    ->setFinder($finder)
    ->setUsingCache(true)
    ->setCacheFile(__DIR__ . '/var/.php-cs-fixer.cache');
