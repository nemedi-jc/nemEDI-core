# Security Configuration Guide

## ⚠️ IMPORTANT SECURITY NOTICE

This repository previously contained exposed server credentials in documentation files. These have been removed for security reasons.

## 🧪 Development Environment Context

This project includes setup instructions for a **sandbox/development Business Central environment** suitable for:
- Development and testing
- API prototyping
- Learning and experimentation
- Client demonstrations

**This is NOT intended for production use without proper security hardening.**

## 🔐 Obtaining Credentials

To get access to the development nemEDI API system:

1. **Contact the Administrator:**
   - Email: info@martinrud.dk
   - Subject: "nemEDI Development API Access Request"

2. **You will receive:**
   - Development server IP address
   - Username and password for testing
   - API endpoint URLs
   - Connection details for VS Code

## 🛠️ Local Configuration

1. Copy `credentials.template.json` to `credentials.json`
2. Fill in the actual values provided by the administrator
3. The `credentials.json` file is automatically ignored by Git
4. Use these credentials only in your local development environment

## 🔒 Security Best Practices

### For Development Environment:
- **Change default passwords** immediately after setup
- **Use strong passwords** (minimum 12 characters with mixed case, numbers, symbols)
- **Restrict network access** to development team only
- **Document access** - know who has credentials
- **Rotate passwords** when team members change
- **Monitor usage** - watch for unusual API activity

### For Production Deployment:
- **Use HTTPS** always (never HTTP in production)
- **Implement proper authentication** (OAuth 2.0, Azure AD, etc.)
- **Network security** - firewalls, VPNs, IP restrictions
- **Regular security audits** and vulnerability assessments
- **Backup and disaster recovery** plans
- **Compliance** with data protection regulations (GDPR, etc.)

## 📝 Credential Storage Template

```json
{
  "development": {
    "server": {
      "ip": "[PROVIDED_BY_ADMIN]",
      "webClientUrl": "http://[SERVER]/BC",
      "apiBaseUrl": "http://[SERVER]:7048/BC/api/"
    },
    "authentication": {
      "username": "[PROVIDED_BY_ADMIN]",
      "password": "[PROVIDED_BY_ADMIN]",
      "basicAuthHeader": "[BASE64_ENCODED_CREDENTIALS]"
    }
  },
  "endpoints": {
    "companies": "/v2.0/companies",
    "reopenSalesOrders": "/nemedi/core/v1.0/companies({companyId})/reopenSalesOrders"
  }
}
```

## 🚨 If Credentials Are Compromised

### Immediate Actions:
1. **Change all passwords** immediately
2. **Review access logs** for unauthorized access
3. **Update firewall rules** to restrict access
4. **Notify all legitimate users** of the credential change
5. **Audit system** for any unauthorized changes

### Investigation:
- Check when credentials were exposed
- Identify potential unauthorized access
- Review system logs for suspicious activity
- Document the incident for future prevention

## 📋 Environment Checklist

### Development Environment Setup:
- [ ] Strong, unique passwords set
- [ ] Network access restricted to development team
- [ ] Credentials stored securely (not in code)
- [ ] .gitignore configured to prevent credential commits
- [ ] Team members trained on security practices

### Production Readiness:
- [ ] HTTPS implemented and enforced
- [ ] Production-grade authentication system
- [ ] Network security measures in place
- [ ] Regular security monitoring enabled
- [ ] Backup and recovery procedures tested
- [ ] Security documentation updated

## 🔍 Additional Resources

- [Business Central Security Best Practices](https://docs.microsoft.com/dynamics365/business-central/security)
- [Azure Security Guidelines](https://docs.microsoft.com/azure/security/)
- [API Security Checklist](https://github.com/shieldfy/API-Security-Checklist)

---

**Last Updated:** October 2025  
**Environment:** Development/Sandbox  
**Security Level:** Basic (Development Only)