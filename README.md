Rust Linux GNU Builder Action
========================

GitHub action for building rust binaries linked to glibc 2.17 (x86_64-unknown-linux-gnu - based on CentOS 7).

> For EOL Linux distribution, CentOS 7, Ubuntu 14 ~ 18, etc.

```yaml
- uses: brightx/rust-gnu2.17-action@1.91
  with:
    args: build --release --all-features
    git_credentials: ${{ secrets.GIT_CREDENTIALS }}
```

### Inputs

| Variable        | Description                                                           | Required | Default           |
|-----------------|-----------------------------------------------------------------------|----------|-------------------|
| args            | Arguments passed to cargo                                             | true     | `build --release` | 
| git_credentials | If provided git will be configured to use these credentials and https | false    |                   |
| directory       | Relative path under $GITHUB_WORKSPACE where Cargo project is located  | false    |                   |
