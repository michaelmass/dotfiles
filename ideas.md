# Dotfiles Improvement Ideas

This document contains suggestions for improving the dotfiles repository based on analysis of the current architecture (88+ tools, rotz-based configuration, dot.yaml pattern).

## High Priority Improvements

### 1. Documentation & Discovery

#### 1.1 Architecture Documentation
- **Create ARCHITECTURE.md** documenting:
  - The rotz orchestration system and how dot.yaml files work
  - Directory structure conventions (one directory per tool)
  - Installation flow (Homebrew/Scoop → rotz → dot.yaml parsing → install/link)
  - Template syntax reference ({{ whoami.arch }}, platform conditionals)
  - Dependency resolution order
  - Path mapping conventions across platforms

#### 1.2 Tool Catalog & Discovery
- **Create TOOLS.md** with categorized tool listing:
  - AI & Development (claude, code, opencode, biome)
  - Shell & Terminal (nushell, bash, oh-my-posh, alacritty, ghostty)
  - Infrastructure & DevOps (docker, tilt, dagger, pulumi, helm, cilium, mise)
  - Languages & Runtimes (node, pnpm, deno, go, rustup, bun)
  - CLI Utilities (ripgrep, fd, eza, jq, zoxide, etc.)
  - Desktop Apps (1password, discord, slack, notion, etc.)
  - Platform-specific tools
- Include one-line descriptions and links to official docs
- Add search/filter mechanism (could be a script: `./search-tool.sh docker`)

#### 1.3 Quick Start Guide
- **Enhance README.md** with:
  - Prerequisites section (OS requirements, disk space, network)
  - What will be installed/changed (transparency)
  - Estimated installation time
  - Common post-install tasks
  - Verification steps (`rotz status`, test key tools)
  - Troubleshooting common issues
- **Create QUICKSTART.md** for:
  - First-time setup walkthrough
  - Selective installation (install only certain tools)
  - Custom configuration tips
  - Platform-specific gotchas

#### 1.4 Contribution Guide
- **Create CONTRIBUTING.md** for adding new tools:
  - dot.yaml template with examples
  - File linking best practices
  - Testing new configurations
  - Platform-specific considerations
  - Naming conventions
  - Commit message format (currently using conventional commits)

### 2. Tool Management & Organization

#### 2.1 Tool Categories
- **Organize tools into subdirectories** (breaking change but improves scalability):
  ```
  tools/
  ├── ai/          (claude, opencode)
  ├── shells/      (nushell, bash, oh-my-posh)
  ├── terminals/   (alacritty, ghostty)
  ├── infra/       (docker, tilt, pulumi, helm)
  ├── languages/   (node, go, rustup)
  ├── cli-utils/   (ripgrep, fd, eza, jq)
  ├── desktop/     (discord, slack, notion)
  └── system/      (git, sudo, coreutils)
  ```
- Update rotz configuration to scan subdirectories
- Maintain backward compatibility with flat structure initially

#### 2.2 Tool Metadata
- **Add metadata to dot.yaml files**:
  ```yaml
  metadata:
    name: Docker
    description: Container runtime and desktop app
    category: infrastructure
    homepage: https://docker.com
    platforms: [windows, linux, darwin]
    tags: [containers, devops]
  ```
- Create tool to generate documentation from metadata
- Enable advanced filtering and discovery

#### 2.3 Dependency Visualization
- **Create dependency graph tool**:
  - Parse all dot.yaml files and extract `depends:` fields
  - Generate visual dependency graph (graphviz/mermaid)
  - Detect circular dependencies
  - Show installation order
  - Example: `./tools/show-deps.sh --tool claude`

### 3. Installation & Setup Improvements

#### 3.1 Selective Installation
- **Create interactive installer**:
  - Profile-based installation (minimal, developer, full)
  - Tag-based selection (install all 'cli-utils')
  - Platform-aware filtering (hide incompatible tools)
  - Dependency auto-inclusion
  - Save selection as profile for future reinstalls
  - Example: `./install.sh --profile developer --only cli-utils,shells`

#### 3.2 Pre-install Validation
- **Create validation script** (`./validate.sh`):
  - Check disk space requirements
  - Verify network connectivity
  - Test package manager availability (brew/scoop)
  - Check for conflicting existing installations
  - Validate dot.yaml syntax across all tools
  - Dry-run mode to preview changes

#### 3.3 Post-install Health Checks
- **Create health check script** (`./healthcheck.sh`):
  - Verify each tool installed successfully
  - Test symlinks are correct
  - Check tool versions
  - Validate configurations
  - Generate installation report
  - Suggest fixes for failures

#### 3.4 Idempotency Testing
- **Add CI/CD pipeline** (.github/workflows/test.yml):
  - Test installation on clean VMs (Ubuntu, macOS, Windows)
  - Run install twice to test idempotency
  - Validate all symlinks created correctly
  - Check for configuration conflicts
  - Test selective installation profiles

### 4. Configuration Management

#### 4.1 Configuration Templates
- **Create templates directory** (`templates/`):
  - Starter configurations for common tools
  - Multiple preset options (minimal, standard, power-user)
  - Platform-specific example configs
  - Documented configuration options
  - Easy switching between templates

#### 4.2 Shared Configuration Patterns
- **Create common/ directory** for shared configs:
  - Color schemes (terminal, editor, prompts)
  - Font configurations
  - Common aliases across shells
  - Keybinding standards
  - Theme synchronization across tools
  - Example: `common/themes/nord.yaml` applied to alacritty, code, etc.

#### 4.3 Secret Management
- **Improve secret handling**:
  - Document best practices for secrets (.env files, 1password integration)
  - Template files for configs requiring secrets (.gitconfig.template)
  - Pre-commit hook to prevent secret commits
  - Integration with 1password CLI for automated secret injection
  - Separate secrets.yaml (gitignored) merged at install time

#### 4.4 Backup & Restore
- **Create backup tool** (`./backup.sh`):
  - Export current configurations before changes
  - Save tool versions and states
  - Create restore points
  - Diff between current and dotfiles versions
  - Selective restore (restore only git config, etc.)

### 5. Development Workflow

#### 5.1 Testing Framework
- **Create test suite** (`tests/`):
  - Unit tests for dot.yaml parsing
  - Integration tests for tool installation
  - Smoke tests for critical tools
  - Platform-specific test coverage
  - Mock installer for fast testing

#### 5.2 Git Hooks Enhancement
- **Expand lefthook configuration** (lefthook.yml currently empty):
  ```yaml
  pre-commit:
    commands:
      lint-yaml:
        run: yamllint */dot.yaml
      validate-links:
        run: ./scripts/validate-links.sh
      check-secrets:
        run: ./scripts/check-secrets.sh
  ```

#### 5.3 Update Management
- **Create update checker** (`./update.sh`):
  - Check for tool updates (brew outdated, scoop status)
  - Notify about dot.yaml changes in upstream
  - Suggest deprecated tool replacements
  - Test updates in isolated environment first
  - Changelog generation for dotfiles updates

#### 5.4 Version Pinning
- **Add version control to dot.yaml**:
  ```yaml
  darwin:
    installs: brew install --formula docker@4.x
    version: 4.25.0  # pin specific version
  ```
- Lock file for reproducible installations
- Update strategy (major/minor/patch)

### 6. Quality of Life Improvements

#### 6.1 Shell Integration
- **Create dotfiles CLI tool** (`~/.local/bin/dotfiles`):
  ```bash
  dotfiles search <tool>      # Find tool config
  dotfiles edit <tool>        # Open tool's dot.yaml
  dotfiles reload <tool>      # Relink/reinstall specific tool
  dotfiles status             # Show health status
  dotfiles update             # Pull latest and reinstall
  dotfiles doctor             # Run diagnostics
  ```

#### 6.2 Configuration Validation
- **JSON Schema for dot.yaml**:
  - Define formal schema for dot.yaml structure
  - Editor integration (VSCode validation)
  - Pre-commit validation
  - Generate documentation from schema

#### 6.3 Performance Optimization
- **Parallel installation**:
  - Identify independent tools (no dependencies)
  - Install in parallel to reduce total time
  - Progress bars and better feedback
  - Partial failure recovery

#### 6.4 Logging & Debugging
- **Enhanced logging**:
  - Installation logs saved to ~/.dotfiles/logs/
  - Verbose mode for troubleshooting
  - Structured logging (JSON format)
  - Log rotation and cleanup
  - Debug mode with detailed trace

### 7. Platform-Specific Improvements

#### 7.1 macOS Optimizations
- **Extend macos/dot.yaml** with system preferences:
  - Dock configuration
  - Finder settings
  - Keyboard shortcuts
  - System UI preferences
  - Security settings
  - Create comprehensive defaults write commands

#### 7.2 Windows Optimizations
- **Windows-specific enhancements**:
  - WSL2 integration setup
  - Windows Terminal configuration
  - PowerShell profile optimization
  - Registry tweaks for developer experience
  - Chocolatey as alternative to Scoop

#### 7.3 Linux Distribution Support
- **Expand Linux support beyond Homebrew**:
  - Detect distro (Ubuntu, Fedora, Arch, etc.)
  - Use native package managers (apt, dnf, pacman)
  - Separate dot.yaml conditionals: `ubuntu:`, `fedora:`

### 8. Claude Code Specific Improvements

#### 8.1 Expand Claude Skills
Current skills: frontend-design, hi, architecture
- **Add more skills**:
  - `/refactor` - Code refactoring with best practices
  - `/test` - Generate comprehensive tests
  - `/docs` - Generate documentation
  - `/security` - Security audit
  - `/performance` - Performance optimization suggestions
  - `/review` - Code review checklist

#### 8.2 Enhanced Hooks
- **Expand claude/hooks/index.ts**:
  - Pre-command validation hooks
  - Post-command cleanup hooks
  - Context enrichment hooks
  - Custom tool integrations
  - Logging and telemetry

#### 8.3 Claude Commands
- **Add more custom commands** (claude/commands/):
  - `/diagram` - Generate architecture diagrams
  - `/api` - API endpoint documentation generator
  - `/migration` - Database migration helper
  - `/deploy` - Deployment checklist

### 9. Advanced Features

#### 9.1 Multi-Machine Sync
- **Machine-specific configurations**:
  - Separate configs per machine type (laptop, desktop, server)
  - Host-specific overrides in dot.yaml
  - Environment-based configs (work vs personal)
  - Sync state across machines (which tools installed where)

#### 9.2 Dotfiles as Code
- **Add Tiltfile automation** (expand existing Tiltfile):
  - Watch dot.yaml changes and auto-reload
  - Local development environment setup
  - Service dependencies (databases, queues)
  - Port forwarding and proxies

#### 9.3 Plugin System
- **External plugin support**:
  - Allow third-party tool definitions
  - Plugin registry or marketplace
  - Version compatibility checking
  - Community contributions

#### 9.4 Migration Tools
- **Migration from other dotfiles managers**:
  - Import from GNU Stow
  - Import from chezmoi
  - Import from yadm
  - Conversion scripts for common patterns

### 10. Documentation Improvements (Detailed)

#### 10.1 Platform Guides
- **MACOS.md**: macOS-specific setup and gotchas
- **WINDOWS.md**: Windows-specific setup and WSL integration
- **LINUX.md**: Linux distribution-specific instructions

#### 10.2 Troubleshooting Guide
- **TROUBLESHOOTING.md**:
  - Common installation errors and fixes
  - Symlink conflicts
  - Permission issues
  - Package manager problems
  - Network/proxy configuration
  - Known incompatibilities

#### 10.3 Tool Guides
- **Individual tool READMEs** (tool/README.md):
  - Why this tool is included
  - Configuration highlights
  - Customization options
  - Integration with other tools
  - Platform-specific notes

#### 10.4 Video Tutorials
- **Supplement written docs with videos**:
  - Installation walkthrough
  - Adding a new tool
  - Customizing configurations
  - Troubleshooting common issues
  - Advanced rotz usage

---

## Low Priority / Future Ideas

### 11. Community & Ecosystem

- **Create dotfiles community hub**:
  - Share configurations with other users
  - Tool recommendation engine
  - Configuration snippets library
  - Discord/forum for support

### 12. Analytics & Insights

- **Installation analytics** (privacy-respecting):
  - Which tools are most commonly installed together
  - Platform distribution
  - Installation success rates
  - Common failure points

### 13. AI Integration

- **AI-powered configuration assistant**:
  - Suggest tools based on workflow
  - Generate custom dot.yaml files
  - Optimize configurations
  - Debug installation issues with Claude

### 14. Security Enhancements

- **Security hardening**:
  - Verify installation script signatures
  - Hash verification for downloaded tools
  - Security audit of dot.yaml scripts
  - Principle of least privilege for installations
  - Sandboxed installation testing

---

## Implementation Priority

**Phase 1 (Immediate):**
1. ARCHITECTURE.md documentation
2. TOOLS.md catalog
3. Improve README.md with troubleshooting
4. Basic healthcheck script
5. dot.yaml validation

**Phase 2 (Short-term):**
1. Selective installation support
2. dotfiles CLI tool
3. Backup/restore functionality
4. Enhanced lefthook configuration
5. Dependency visualization

**Phase 3 (Medium-term):**
1. Tool categorization (subdirectories)
2. Configuration templates
3. Testing framework
4. CI/CD pipeline
5. Update management

**Phase 4 (Long-term):**
1. Multi-machine sync
2. Plugin system
3. Advanced Tiltfile automation
4. Community hub
5. AI integration

---

## Notes

- Current repository is well-structured with consistent patterns
- rotz-based approach is solid and scalable
- Main gaps are in documentation, discovery, and quality-of-life tooling
- Most improvements can be added incrementally without breaking changes
- Focus on user experience and maintainability

**Last Updated:** 2026-02-02
**Repository Stats:** 88+ tools, 3 shells (nushell/bash/oh-my-posh), 2 terminals (alacritty/ghostty), rotz-based orchestration
