# Deploying OpenCog WebVM to GitHub Pages

This guide explains how to deploy the OpenCog-enabled WebVM to GitHub Pages.

## Prerequisites

1. GitHub account with GitHub Pages enabled
2. Forked repository from `leaningtech/webvm` or this repository
3. GitHub Actions enabled for your repository

## Deployment Steps

### 1. Enable GitHub Pages

1. Go to your repository's **Settings**
2. Navigate to the **Pages** section
3. Under "Build and deployment", select **GitHub Actions** as the source
4. If using a custom domain, ensure **Enforce HTTPS** is enabled

### 2. Run the Deploy Workflow

1. Go to the **Actions** tab in your repository
2. Click on the **Deploy** workflow
3. Click **Run workflow**
4. Configure the workflow parameters:
   - **Path to the Dockerfile**: `dockerfiles/opencog_cogserver`
   - **Image size**: `900M` (recommended) or `950M` (maximum)
   - **Deploy to Github pages**: `true`
   - **Upload GitHub release**: `false` (or `true` if you want to create a release)
5. Click **Run workflow**

### 3. Monitor the Build

The workflow will:
1. Build the Docker image from the Dockerfile
2. Extract the filesystem to an ext2 image
3. Split the image into chunks for web serving
4. Deploy to GitHub Pages

The process typically takes 20-40 minutes depending on:
- GitHub Actions runner availability
- Build complexity
- Image size

### 4. Access Your Deployment

After the workflow completes successfully:
1. The URL will be shown in the workflow logs under `deploy_to_github_pages`
2. Typically: `https://[username].github.io/[repository-name]/`
3. Or your custom domain if configured

## Size Optimization

If your build exceeds 950M:

### Check Image Size in Workflow
The workflow will fail if the image is too large. Check the logs for:
```
-rw-r--r-- 1 runner docker XXX Jan 10 16:00 opencog_cogserver_YYYYMMDD_RUNID.ext2
```

### Reduce Size
Edit `dockerfiles/opencog_cogserver`:

1. **Remove optional packages**:
   ```dockerfile
   # Remove vim-tiny if not needed
   # Remove rlwrap if command history isn't critical
   ```

2. **Minimize examples**:
   ```dockerfile
   # Copy only essential examples
   COPY --chown=user:user ./examples/opencog/README.md /home/user/opencog-examples/
   ```

3. **Strip more aggressively**:
   ```dockerfile
   RUN strip --strip-all /usr/local/bin/* /usr/local/lib/*.so* 2>/dev/null || true
   ```

4. **Remove more files**:
   ```dockerfile
   RUN rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/info/*
   ```

### Test Locally First
Before deploying to GitHub Pages, test the size locally:

```bash
docker build . --tag opencog-webvm --file dockerfiles/opencog_cogserver --platform=i386
docker images opencog-webvm
# Check the SIZE column
```

## Troubleshooting

### Build Fails - Dependency Issues
- Check that all dependencies are available for i386/Debian Bookworm
- Verify package names with: `apt-cache search <package>`

### Build Fails - Size Exceeds 950M
- Follow the size optimization steps above
- Consider removing non-essential features

### Runtime Errors After Deployment
- Check browser console for errors
- Verify the image size workflow parameter matches reality
- Check that all shared libraries are present

### CogServer Won't Start
- In WebVM terminal, check: `which cogserver`
- Test manually: `cogserver`
- Check for missing libraries: `ldd /usr/local/bin/cogserver`

### Guile Module Not Found
- Verify guile paths in .guile configuration
- Check that modules were copied: `ls /usr/local/share/guile/`

## Production Deployment Checklist

Before deploying to production:

- [ ] Test locally with Docker
- [ ] Verify image size < 950M
- [ ] Test CogServer starts correctly
- [ ] Test all example scripts work
- [ ] Test Claude AI integration
- [ ] Verify welcome message displays
- [ ] Check performance in WebVM (slower than native)
- [ ] Test on multiple browsers (Chrome, Firefox, Safari)
- [ ] Review security (no sensitive data in image)
- [ ] Update documentation if needed

## Post-Deployment

After successful deployment:

1. **Test the live instance**:
   - Open the URL
   - Wait for WebVM to load (may take 1-2 minutes)
   - Type `cogserver` to start the server
   - Test basic commands

2. **Share with users**:
   - Provide the URL
   - Share the README documentation
   - Point to examples in `~/opencog-examples/`

3. **Monitor usage**:
   - Check GitHub Pages analytics (if enabled)
   - Review any issues reported
   - Update based on feedback

## Updating the Deployment

To update after changes:

1. Make changes to code/Dockerfile
2. Commit and push to your repository
3. Re-run the Deploy workflow
4. GitHub Pages will automatically update

## Custom Domain (Optional)

To use a custom domain:

1. In repository Settings > Pages:
   - Enter your custom domain
   - Enable HTTPS enforcement
2. Configure DNS:
   - Add CNAME record pointing to `[username].github.io`
3. Wait for DNS propagation (up to 24 hours)

## Cost

GitHub Pages hosting is free for public repositories with limitations:
- 100GB bandwidth per month
- 1GB repository size
- Published sites may be no larger than 1GB

For higher usage, consider:
- GitHub Pro/Enterprise
- Alternative hosting (Netlify, Vercel, etc.)

## Support

For issues specific to:
- **OpenCog functionality**: Check OpenCog wiki and GitHub issues
- **WebVM platform**: Check WebVM GitHub issues
- **Deployment**: Review GitHub Actions logs
- **This repository**: Open an issue

## Resources

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [WebVM Documentation](https://github.com/leaningtech/webvm)
- [OpenCog Wiki](https://wiki.opencog.org/)
