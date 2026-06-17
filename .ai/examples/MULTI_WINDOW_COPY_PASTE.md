# Multi-Window Copy Paste Example

Main window:

```text
/parallel build checkout
```

Worker windows:

```text
/agent backend resume checkout-backend
```

```text
/agent frontend resume checkout-frontend
```

```text
/agent qa resume checkout-qa
```

```text
/agent docs resume checkout-docs
```

Reviewer:

```text
/agent reviewer resume checkout-review
```

Final:

```text
/parallel merge checkout
```
