# Contributing to GEMVC

Thank you for considering contributing to GEMVC! This document outlines the process for contributing to this project.

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Development Process

We use GitHub Flow for our development process:

1. Fork the repository
2. Create a feature branch from `develop`
3. Make your changes
4. Write or update tests
5. Ensure all tests pass
6. Submit a Pull Request

## Branch Naming Convention

- `feature/` - New features (e.g., `feature/graphql-integration`)
- `bugfix/` - Bug fixes (e.g., `bugfix/auth-token-expiry`)
- `hotfix/` - Critical fixes for production (e.g., `hotfix/security-patch`)
- `refactor/` - Code refactoring (e.g., `refactor/database-layer`)
- `docs/` - Documentation updates (e.g., `docs/api-examples`)
- `test/` - Test additions or fixes (e.g., `test/unit-coverage`)

## Commit Message Format

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `build`: Build system changes
- `ci`: CI configuration changes
- `chore`: Routine tasks, maintenance

### Examples:
```
feat(api): add GraphQL endpoint support

- Implement GraphQL schema builder
- Add query and mutation resolvers
- Include subscription support

Closes #2
```

```
fix(auth): resolve JWT token expiration issue

The token was not being refreshed properly when nearing expiration.
This fix implements automatic token refresh 5 minutes before expiry.

Fixes #45
```

## Pull Request Process

1. **Update Documentation**: Ensure any new features or changes are documented
2. **Add Tests**: Include unit and integration tests for new functionality
3. **Update CHANGELOG**: Add your changes to the Unreleased section
4. **Pass CI Checks**: Ensure all GitHub Actions workflows pass
5. **Code Review**: At least one maintainer must review and approve

### PR Title Format
Follow the same convention as commit messages:
- `feat: Add queue system for background jobs`
- `fix: Resolve database connection pooling issue`
- `docs: Update installation guide`

## Testing

### Running Tests Locally

```bash
# Run all tests
composer test

# Run unit tests only
composer test:unit

# Run integration tests
composer test:integration

# Run with coverage
composer test:coverage

# Run static analysis
composer analyse

# Check code style
composer cs-check

# Fix code style
composer cs-fix
```

### Test Structure

```
tests/
├── Unit/           # Unit tests
├── Integration/    # Integration tests
├── Feature/        # Feature tests
└── TestCase.php    # Base test class
```

## Code Style

We follow PSR-12 coding standards with some additions:

- Use type declarations for parameters and return types
- Use strict types (`declare(strict_types=1);`)
- Document complex logic with inline comments
- Keep methods under 20 lines when possible
- Prefer composition over inheritance

### Example:

```php
<?php

declare(strict_types=1);

namespace Gemvc\Core;

use Gemvc\Contracts\ServiceInterface;

final class ExampleService implements ServiceInterface
{
    public function __construct(
        private readonly DatabaseConnection $connection,
        private readonly CacheManager $cache
    ) {
    }

    public function process(array $data): Result
    {
        // Validate input data
        $validated = $this->validate($data);
        
        // Check cache first
        if ($cached = $this->cache->get($this->getCacheKey($validated))) {
            return $cached;
        }
        
        // Process and cache result
        $result = $this->doProcess($validated);
        $this->cache->put($this->getCacheKey($validated), $result, 3600);
        
        return $result;
    }
}
```

## Documentation

- Add PHPDoc blocks for all public methods
- Include `@throws` annotations for exceptions
- Document complex algorithms
- Update README for new features
- Add examples for new functionality

## Issue Guidelines

### Creating Issues

Use issue templates and include:
- Clear, descriptive title
- Detailed description
- Steps to reproduce (for bugs)
- Expected vs actual behavior
- Environment details
- Code examples if applicable

### Issue Labels

Issues will be labeled by maintainers:
- `type:*` - Issue type
- `priority:*` - Priority level
- `component:*` - Affected component
- `effort:*` - Estimated effort
- `status:*` - Current status

## Release Process

1. Features are developed in feature branches
2. Merged into `develop` for testing
3. Release branches created from `develop`
4. After testing, merged to `main` and tagged
5. Hotfixes branch from `main` and merge back

## Getting Help

- Check existing issues and discussions
- Join our Discord server (link in README)
- Read the documentation
- Ask in GitHub Discussions

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Given credit in the changelog

Thank you for contributing to GEMVC! 🚀