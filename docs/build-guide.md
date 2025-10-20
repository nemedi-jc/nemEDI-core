# Building the nemEDI Extension

This guide explains how to build the nemEDI Business Central extension into a deployable `.app` file.

## 📋 Prerequisites

### Required Software
- **Visual Studio Code** with AL Language extension
- **Business Central Development Environment** (local or cloud)
- **AL Language Extension** (ms-dynamics-smb.al)
- **PowerShell** (for automation scripts)

### Required Symbols
Before building, you need to download symbols for your target Business Central version:

```
AL: Download Symbols
```

Or via Command Palette: `Ctrl+Shift+P` → `AL: Download Symbols`

## 🏗️ Build Methods

### Method 1: VS Code AL Extension (Recommended)

#### Step 1: Download Symbols
1. Open the project in VS Code
2. Press `Ctrl+Shift+P` to open Command Palette
3. Type and select: `AL: Download Symbols`
4. Wait for symbol download to complete

#### Step 2: Build the Extension
1. Press `Ctrl+Shift+P` to open Command Palette
2. Type and select: `AL: Package`
3. The `.app` file will be created in the project root directory

**Output:** `nemEDI Core_1.0.0.1.app`

### Method 3: PowerShell AL Commands

```powershell
# Download symbols first
Install-Module -Name BcContainerHelper -Force
Import-Module BcContainerHelper

# Compile and package
Compile-AppInBcContainer -containerName "your-bc-container" -appProjectFolder "." -CreateRuntimePackage

# Or if using cloud development
Compile-AppInNavContainer -appProjectFolder "." -CreateRuntimePackage
```

## 📁 Build Output

### Generated Files
```
nemEDI-core/
├── src/                              # Source code
├── app.json                          # Project configuration  
├── .alpackages/                      # Downloaded symbols
├── nemEDI Core_1.0.0.1.app          # ✅ Built extension package
└── launch.json                       # Development configuration
```

### App File Location
The built `.app` file will be in the project root with the naming pattern:
```
[Publisher] [Name]_[Version].app
```

Example: `nemEDI nemEDI Core_1.0.0.1.app`

## 🔧 Build Configuration

### app.json Settings
Key settings that affect the build:

```json
{
  "id": "5b09230a-a879-4836-b302-4e86b7955008",
  "name": "nemEDI Core",
  "publisher": "nemEDI", 
  "version": "1.0.0.1",
  "application": "25.0.0.0",
  "runtime": "12.0",
  "target": "Cloud",
  "idRanges": [{ "from": 50100, "to": 50149 }]
}
```

## 🚀 Build for Different Environments

### Development Build
For testing and development:
```
AL: Package
```
- Includes source code in symbols
- Debugging enabled
- Development features active

### Production Build  
For client deployment:
1. Update `app.json` version number
2. Set production-ready configuration
3. Build with `AL: Package`
4. Test thoroughly before deployment

## 📦 Deployment Process

### Step 1: Build the Extension
```
AL: Package
```

### Step 2: Publish to Business Central
```
AL: Publish
```
Or manually upload via:
- Business Central Admin Center (SaaS)
- Extension Management page (On-Premises)

### Step 3: Install and Configure
1. **Install Extension** in target environment
2. **Assign Permissions** - Add `NemediApiRWM` permission set to API users
3. **Test API Endpoints** - Verify functionality works

## 🔍 Troubleshooting Build Issues

### Common Build Errors

#### "Symbols not found"
**Solution:**
```
AL: Download Symbols
```
Ensure you have the correct Business Central version symbols.

#### "Compilation failed"
**Causes:**
- Syntax errors in AL code
- Missing dependencies
- ID range conflicts

**Solution:**
1. Check the Output panel for detailed errors
2. Fix syntax issues in source files
3. Verify ID ranges in `app.json`

#### "Permission denied"
**Solution:**
- Close Business Central client
- Run VS Code as Administrator
- Check file permissions

### Build Warnings
Common warnings and solutions:

#### "Translation missing"
```
Warning AL0542: Translation for 'LabelName' is missing
```
**Solution:** Add proper Label translations for multi-language support.

#### "Obsolete method"
```
Warning AL0432: Method 'OldMethod' is obsolete
```
**Solution:** Update to use newer AL methods and APIs.

## 🧪 Testing the Built Extension

### Pre-Deployment Testing
1. **Install in Development Environment**
   ```
   AL: Publish
   ```

2. **Test API Endpoints**
   ```http
   POST http://[dev-server]:7048/BC/api/nemedi/core/v1.0/companies(company-id)/reopenSalesOrders
   ```

3. **Verify Permissions**
   - Assign `NemediApiRWM` permission set
   - Test with non-admin user

### Post-Deployment Validation
1. **API Response Testing**
2. **Business Logic Validation** 
3. **Error Handling Verification**
4. **Performance Testing**

## 📋 Build Checklist

Before building for production:

### Code Quality
- [ ] All AL files compile without errors
- [ ] No blocking warnings
- [ ] Code follows AL development best practices
- [ ] XML documentation completed

### Configuration
- [ ] Version number updated in `app.json`
- [ ] Target environment set correctly
- [ ] ID ranges verified
- [ ] Dependencies listed

### Testing
- [ ] Extension tested in development environment
- [ ] API endpoints functional
- [ ] Permission sets working
- [ ] Error handling tested

### Documentation
- [ ] README.md updated
- [ ] API documentation current
- [ ] Installation guide prepared

## 🔄 Automated Build (Optional)

### PowerShell Build Script
Create `build.ps1`:

```powershell
# Build script for nemEDI Core extension
Write-Host "🏗️ Building nemEDI Core Extension..." -ForegroundColor Green

# Step 1: Download symbols
Write-Host "📥 Downloading symbols..." -ForegroundColor Yellow
code --command "AL.downloadSymbols"

# Step 2: Package extension  
Write-Host "📦 Packaging extension..." -ForegroundColor Yellow
code --command "AL.package"

# Step 3: Verify build
$appFile = Get-ChildItem -Name "*.app" | Select-Object -First 1
if ($appFile) {
    Write-Host "✅ Build successful: $appFile" -ForegroundColor Green
    Write-Host "📁 Location: $(Get-Location)\$appFile" -ForegroundColor Cyan
} else {
    Write-Host "❌ Build failed - no .app file generated" -ForegroundColor Red
}
```

### Usage
```powershell
.\build.ps1
```

## 📈 Version Management

### Semantic Versioning
Follow semantic versioning for `app.json`:
- **Major.Minor.Patch.Build**
- Example: `1.0.0.1` → `1.0.0.2` (patch) → `1.1.0.0` (feature) → `2.0.0.0` (breaking)

### Build History
Keep track of builds:
- Tag releases in Git: `git tag v1.0.0.1`
- Document changes in release notes
- Archive built `.app` files

---

## 🎯 Quick Build Commands

| Action | Command | Shortcut |
|--------|---------|----------|
| Download Symbols | `AL: Download Symbols` | - |
| Build Package | `AL: Package` | `Ctrl+Shift+P` |
| Publish Local | `AL: Publish` | `Ctrl+F5` |
| Build & Publish | `AL: Publish` | `F5` |

---

**Built extension ready for deployment!** 🚀

The `.app` file can now be installed in any Business Central environment that matches the target configuration.