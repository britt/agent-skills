# Release Notes

## 2.0.0

This release introduces the 2.0.0 bundle update, clarifies installation around the full skills collection, and adds release guidance for semantic versioning.

### Breaking Changes

* Removed individual marketplace entries, so the `/plugin install britt/<skill-name>` flow no longer works and installation now happens through the full `britt/claude-code-skills` bundle.
* Retired zip archive downloads and removed `package.sh`, so Claude.ai installations now use a cloned repository with uploaded skill directories instead of downloaded archives.