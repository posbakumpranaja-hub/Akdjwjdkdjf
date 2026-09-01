# 🤝 Contributing Guidelines

Terima kasih telah ingin berkontribusi ke InstaReporter Termux Documentation!

## 📋 Code of Conduct

Sebelum berkontribusi, baca & pahami:
- Jadilah respectful kepada semua orang
- Hindari harassment, discrimination, spam
- Diskusi konstruktif & helpful
- Laporkan pelanggaran ke maintainer

## 🚀 Cara Berkontribusi

### 1. Fork Repository
```bash
# Fork di GitHub UI
# Kemudian clone fork Anda
git clone https://github.com/YOUR-USERNAME/Akdjwjdkdjf.git
cd Akdjwjdkdjf
```

### 2. Create Feature Branch
```bash
git checkout -b feature/your-feature-name
# atau
git checkout -b fix/your-bug-fix
```

### 3. Make Changes
- Edit files sesuai kebutuhan
- Follow formatting guidelines
- Test perubahan Anda
- Commit dengan clear message

### 4. Commit dengan Clear Messages
```bash
git add .
git commit -m "Add/Fix: Brief description of changes"

# Format:
# Add: Untuk fitur baru
# Fix: Untuk bug fixes
# Update: Untuk improvements
# Doc: Untuk dokumentasi
# Style: Untuk formatting
```

### 5. Push & Create Pull Request
```bash
git push origin feature/your-feature-name
```

Kemudian buka Pull Request di GitHub dengan:
- Judul yang jelas
- Deskripsi lengkap
- Link ke related issues (jika ada)

## 📝 Types of Contributions

### Documentation
- Improve README atau guides
- Fix typos & grammar
- Add examples
- Translate ke bahasa lain

### Code
- Add features
- Fix bugs
- Optimize performance
- Add tests

### Issues
- Report bugs
- Suggest features
- Ask questions
- Share ideas

## 📏 Style Guidelines

### Markdown Files
```markdown
# Heading 1
## Heading 2
### Heading 3

**Bold text**
*Italic text*
`Code inline`

```bash
Code block
```

- Bullet point
- Another point

1. Numbered list
2. Another item
```

### Bash Scripts
```bash
#!/bin/bash

# Use descriptive variable names
VARIABLE_NAME="value"

# Add comments for complex logic
function descriptive_name() {
    # Do something
    command
}
```

### Python Code
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Module docstring."""

import sys
import os

def function_name():
    """Function docstring."""
    pass
```

## 🐛 Reporting Bugs

Jika menemukan bug, buat Issue dengan:

**Title**: Clear description
```
[BUG] Installation fails on Android 5
```

**Description**:
```markdown
## Description
Clear description of the bug

## Steps to Reproduce
1. Install Termux
2. Run setup_wizard.sh
3. Error appears

## Expected Behavior
Script should complete successfully

## Actual Behavior
Script fails with error: ...

## Environment
- OS: Android 5.0
- Termux version: 0.100
- Python version: 3.9
- Device: Xiaomi Mi 8

## Error Log
```
error message here
```
```

## ✨ Suggesting Features

**Title**: Clear feature description
```
[FEATURE] Add Docker support
```

**Description**:
```markdown
## Proposal
Add Docker containerization support

## Problem
Hard to setup on some systems

## Solution
Create Dockerfile for easy deployment

## Benefits
- Easier setup
- Cross-platform
- Reproducible environment
```

## ✅ Review Process

1. **Automated Checks**
   - Code format validation
   - Link validation
   - Spell check

2. **Maintainer Review**
   - Code quality
   - Documentation completeness
   - Alignment dengan project goals

3. **Community Discussion**
   - Feedback dari users
   - Suggestions & improvements

4. **Approval & Merge**
   - Approval dari maintainer
   - Merge ke main branch
   - Close associated issues

## 🎓 Learning Resources

- [Git & GitHub Basics](https://guides.github.com/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Bash Scripting](https://www.gnu.org/software/bash/manual/)
- [Python Best Practices](https://www.python.org/dev/peps/pep-0008/)

## 💬 Questions?

- Open an Issue dengan tag `[QUESTION]`
- Join discussions
- Cek FAQ.md

---

**Thank you for contributing! 🙏**
