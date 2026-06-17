# No Magic Abstractions

Prodige Workflow favors **explicit over clever**. Code generated should be straightforward, not "magically" abstracted or overly clever.

## Why This Is Out of Scope

Aligned with Karpathy Behavioral Guidelines (Simplicity First):
> "No abstractions for single-use code"
> "No flexibility that wasn't requested"

### 1. Maintainability
Clever code is hard to:
- **Understand** (requires domain expertise)
- **Debug** (hidden complexity)
- **Modify** (tight coupling)
- **Onboard** (steep learning curve)

### 2. Over-Engineering
AI agents naturally tend toward complexity:
- Strategy patterns for one use case
- Abstract base classes for one implementation
- Configuration systems for one value
- "Flexible" architectures with no second use case

### 3. False Flexibility
"Future-proof" abstractions often guess wrong:
- Premature generalization
- Wrong abstraction boundaries
- Unused extension points
- Configuration no one changes

## What Counts as "Magic"

❌ **Magic (Avoid)**:
```python
# Abstract factory for one product type
class VehicleFactory(ABC):
    @abstractmethod
    def create_vehicle(self) -> Vehicle: pass

class CarFactory(VehicleFactory):
    def create_vehicle(self) -> Car:
        # Only one implementation, why abstract?
```

✅ **Explicit (Prefer)**:
```python
# Just create the car directly
def create_car(model: str) -> Car:
    return Car(model=model)
```

---

❌ **Magic**:
```javascript
// Configurable plugin system for one plugin
class PluginManager {
  constructor() { this.plugins = new Map(); }
  register(name, plugin) { this.plugins.set(name, plugin); }
  execute(name, context) { /*...*/ }
}
// Only one plugin ever registered!
```

✅ **Explicit**:
```javascript
// Just call the function
function validateUser(user) {
  // Direct implementation
}
```

---

❌ **Magic**:
```go
// Reflection-based generic handler
func HandleRequest[T any](req Request) (T, error) {
    // Uses reflection to route to correct handler
    // 200 lines of abstraction for 3 request types
}
```

✅ **Explicit**:
```go
// Direct routing
func HandleUserRequest(req UserRequest) (UserResponse, error) { /*...*/ }
func HandleOrderRequest(req OrderRequest) (OrderResponse, error) { /*...*/ }
func HandlePaymentRequest(req PaymentRequest) (PaymentResponse, error) { /*...*/ }
```

## Escape Hatches

### When Abstraction IS Justified

Abstraction makes sense when:
1. **2+ concrete implementations** exist NOW (not hypothetical future)
2. **Varying behavior** that can't be parameterized
3. **External interface** required (plugin system, API contracts)

Example of justified abstraction:
```python
# Payment processing with 3 real providers
class PaymentProvider(ABC):
    @abstractmethod
    def charge(self, amount: Money, card: Card) -> Receipt: pass

class StripeProvider(PaymentProvider):
    # Real implementation

class PayPalProvider(PaymentProvider):
    # Real implementation

class BraintreeProvider(PaymentProvider):
    # Real implementation
```

This is OK because:
- ✅ Three real implementations
- ✅ Actual behavior variation
- ✅ Runtime provider selection needed

### When Configuration IS Justified

Configuration makes sense when:
1. **Different environments** require different values (dev/staging/prod)
2. **User preferences** that actually vary
3. **Feature flags** for gradual rollout

Example of justified config:
```yaml
# Different per environment
database:
  host: ${DB_HOST}
  port: ${DB_PORT}
  name: ${DB_NAME}
```

Not justified:
```yaml
# Only one value ever used
api:
  version: "v1"  # Never changes, why config?
  timeout: 30    # Never changes, why config?
```

## What Prodige Does

### ✅ Generates Simple Code
- Direct implementations
- No premature abstraction
- Parameterized functions over strategy patterns
- Config only when truly needed

### ❌ Will NOT Generate
- Abstract factories for one type
- Plugin systems for one plugin
- Generic handlers with reflection for few types
- Overly defensive code for impossible errors
- Configuration for values that never change

## Testing the Abstraction

Ask these questions:

**1. The Second Use Case Test**
> "What's the ACTUAL second use case for this abstraction?"

If answer is "well, we might need it someday" → Remove abstraction

**2. The Removal Test**
> "If I inline this abstraction, how much simpler is the code?"

If answer is "much simpler" → Inline it

**3. The Explanation Test**
> "Can a junior developer understand this in 30 seconds?"

If answer is "no, they'd need to understand the pattern first" → Simplify

## Philosophy Alignment

From SOUL.md:
> "Simple beats clever"

Clever abstractions feel smart but hurt maintainability.

> "Minimal coupling"

Magic abstractions create tight coupling to abstract interfaces.

From Karpathy guidelines:
> "If you write 200 lines and it could be 50, rewrite it"

Abstractions often add 4x code for no benefit.

## Examples from Prodige

### Design Workflow
When `/design` is asked to create architecture:

❌ **Avoid**:
```
Microservices with:
- Event sourcing
- CQRS
- Saga pattern
- Service mesh
... for a simple CRUD app
```

✅ **Prefer**:
```
Monolith with:
- Clear module boundaries
- Direct database calls
- REST API
- Simple deployment
```

### Build Workflow
When `/build` implements features:

❌ **Avoid**:
```python
# Base classes, interfaces, strategies for simple validation
class ValidatorInterface(ABC): ...
class ValidationStrategy(ABC): ...
class ValidationContext: ...
# 300 lines for "check if email is valid"
```

✅ **Prefer**:
```python
# Direct function
def validate_email(email: str) -> bool:
    return re.match(r"[^@]+@[^@]+\.[^@]+", email) is not None
```

## Prior Requests

- None yet (boundary aligned with existing Karpathy guidelines)

## Related Guidelines

See also:
- `.ai/skills/karpathy-behavioral.md` (Simplicity First)
- `.ai/governance/rules.md` (The Overcomplication Test)
- `.ai/SOUL.md` (Principle 3: Simple beats clever)

---

**Remember**: When in doubt, choose boring and simple over clever and flexible.
