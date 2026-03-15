<?php

declare(strict_types=1);

use TwigCsFixer\Config\Config;
use TwigCsFixer\File\Finder;
use TwigCsFixer\Standard\TwigCsFixer;

$finder = Finder::new()
    ->in(__DIR__ . '/templates');

return (new Config())
    ->setStandard(new TwigCsFixer())
    ->addFinder($finder);
