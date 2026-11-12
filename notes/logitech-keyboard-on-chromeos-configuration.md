---
title: Logitech Keyboard on ChromeOS Configuration
tags: [hardware:keyboard, os:chromeos]
---

Logitech keyboards (such as the MX Keys Mini) have somewhat obscure firmware (see the hardwired `fn` key) that gets worse if you're used to Apple keyboards and want to mimic them on ChromeOS.

The keyboard's firmware uses two modes: Windows and Mac. To switch between them, hold `fn-O` (Mac) or `fn-P` (Windows) for three seconds until the keyboard light blinks.

With the keyboard in Mac mode, a nice setup is shown below — go to Settings > Device > Customize Keyboard Keys:

- Meta: `ctrl`
- Ctrl: `ctrl`
- Alt: `alt`
- Caps lock: `launcher`

It's opinionated, but it works well for me in 2026.

## Sources
- [Logitech MX Keys Mini Getting Started Guide](https://support.logi.com/hc/en-us/articles/4407047895447)
