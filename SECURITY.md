# 🔐 Security Policy

## Reporting Security Vulnerabilities

Jika Anda menemukan security vulnerability, **JANGAN buat public issue**.

### Cara Melaporkan

1. **Email Maintainer**
   - Email: [maintainer email]
   - Subject: `[SECURITY] Vulnerability Report`
   - Include details lengkap

2. **Provide**
   - Description vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (jika ada)

3. **Timeline**
   - Kami akan acknowledge dalam 24 jam
   - Investigate & develop patch
   - Release patch secepatnya
   - Public disclosure setelah patch available

## Security Best Practices

### Jangan Pernah

- ❌ Share credentials atau API keys
- ❌ Commit sensitive data
- ❌ Use weak passwords
- ❌ Trust unknown proxies completely
- ❌ Disable security warnings

### Selalu Lakukan

- ✅ Use strong, unique proxy lists
- ✅ Rotate credentials regularly
- ✅ Monitor account activity
- ✅ Use VPN + Proxy combination
- ✅ Keep software updated
- ✅ Review logs regularly

## Proxy Security

### Quality Proxy Selection

```bash
# Hindari
- Free proxy dari source tidak jelas
- Proxy dengan uptime rendah
- Proxy dari negara high-risk

# Gunakan
- Residential proxies (reputable seller)
- Datacenter proxies (major providers)
- Mix keduanya untuk optimal
```

### Proxy Testing

```bash
# Test sebelum digunakan
bash check_proxies.sh

# Remove dead proxies
grep -v '^$' proxies_dead.txt >> proxies_blacklist.txt
```

## Data Privacy

### What We Collect

- ❌ NOTHING - Project local only
- Your data stays on your device
- No cloud sync
- No telemetry

### What You Should Know

- Proxy provider dapat log activity
- Instagram dapat detect patterns
- Use responsibly
- Monitor account health

## Account Security

### Protect Your Account

1. **Use Alt Account**
   - Don't use main personal account
   - Keep alt separate
   - Monitor regularly

2. **Enable 2FA**
   - Two-factor authentication
   - Strong backup codes
   - Recovery email updated

3. **Monitor Activity**
   - Check login history
   - Review connected apps
   - Revoke unknown sessions

4. **Rate Limiting**
   - Slow requests = less detection
   - Avoid massive bursts
   - Spread over time

## Legal Compliance

### Know Your Laws

- ⚖️ GDPR (Europe)
- ⚖️ CCPA (California)
- ⚖️ Local data protection laws
- ⚖️ Terms of Service violations

### Ethical Use

- ✅ Research purposes only
- ✅ Permission-based automation
- ✅ Respect user privacy
- ✅ Follow platform ToS

---

**Security is everyone's responsibility. Thank you for helping keep this project safe! 🙏**
