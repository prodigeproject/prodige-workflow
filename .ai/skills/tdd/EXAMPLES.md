# TDD Examples: Good vs Bad Tests

Concrete examples showing the difference between behavior-focused tests (good) and implementation-coupled tests (bad).

---

## Example 1: User Authentication (Backend)

### ❌ BAD: Implementation-Coupled

```typescript
// BAD: Tests internal implementation
describe('AuthService', () => {
  it('calls hashPassword when creating user', async () => {
    const mockHash = jest.spyOn(crypto, 'hashPassword');
    await authService.createUser({ email: 'test@example.com', password: 'pass123' });
    
    expect(mockHash).toHaveBeenCalledWith('pass123');
  });
  
  it('sets token in response', async () => {
    const user = await authService.login('test@example.com', 'pass123');
    expect(user.token).toBeDefined();
    expect(typeof user.token).toBe('string');
  });
});
```

**Problems**:
- Tests HOW password is hashed (internal detail)
- Tests response structure, not behavior
- Breaks if you switch from crypto.hashPassword to bcrypt
- Breaks if you rename token field to authToken

### ✅ GOOD: Behavior-Focused

```typescript
// GOOD: Tests actual auth behavior
describe('User Authentication', () => {
  it('allows login with correct credentials', async () => {
    // Setup: Create user
    await createUser({ email: 'test@example.com', password: 'pass123' });
    
    // Test: Can login
    const result = await login('test@example.com', 'pass123');
    expect(result.success).toBe(true);
  });
  
  it('rejects login with wrong password', async () => {
    await createUser({ email: 'test@example.com', password: 'pass123' });
    
    const result = await login('test@example.com', 'wrongpass');
    expect(result.success).toBe(false);
  });
  
  it('authenticated user can access protected resource', async () => {
    const { token } = await login('test@example.com', 'pass123');
    
    const profile = await getProfile(token);
    expect(profile.email).toBe('test@example.com');
  });
});
```

**Why Better**:
- Tests user-facing behavior
- Doesn't care HOW password is hashed
- Doesn't care about token structure
- Survives internal refactors

---

## Example 2: Shopping Cart (Frontend)

### ❌ BAD: Implementation-Coupled

```typescript
// BAD: Tests component internals
describe('CartComponent', () => {
  it('updates state.items when addItem called', () => {
    const cart = render(<Cart />);
    const instance = cart.instance();
    
    instance.addItem(product);
    expect(instance.state.items).toHaveLength(1);
  });
  
  it('calls calculateTotal method on render', () => {
    const spy = jest.spyOn(Cart.prototype, 'calculateTotal');
    render(<Cart items={[product]} />);
    
    expect(spy).toHaveBeenCalled();
  });
});
```

**Problems**:
- Tests internal state (implementation detail)
- Tests internal methods being called
- Breaks if you switch from class component to hooks
- Breaks if you rename methods

### ✅ GOOD: Behavior-Focused

```typescript
// GOOD: Tests user-visible behavior
describe('Shopping Cart', () => {
  it('shows empty cart message when no items', () => {
    render(<Cart />);
    expect(screen.getByText('Your cart is empty')).toBeInTheDocument();
  });
  
  it('displays product after adding to cart', async () => {
    render(<Cart />);
    
    await userEvent.click(screen.getByRole('button', { name: 'Add to Cart' }));
    
    expect(screen.getByText('Product Name')).toBeInTheDocument();
    expect(screen.getByText('$19.99')).toBeInTheDocument();
  });
  
  it('updates total when quantity changed', async () => {
    render(<Cart items={[{ name: 'Product', price: 10 }]} />);
    
    const quantityInput = screen.getByLabelText('Quantity');
    await userEvent.clear(quantityInput);
    await userEvent.type(quantityInput, '3');
    
    expect(screen.getByText('Total: $30.00')).toBeInTheDocument();
  });
});
```

**Why Better**:
- Tests what user sees and does
- Doesn't care about internal state structure
- Doesn't care about hooks vs classes
- Survives refactors

---

## Example 3: API Integration (Backend)

### ❌ BAD: Over-Mocked

```typescript
// BAD: Mocks everything, tests nothing
describe('OrderService', () => {
  it('creates order', async () => {
    const mockDb = { insert: jest.fn().mockResolvedValue({ id: 1 }) };
    const mockEmail = { send: jest.fn() };
    const mockInventory = { reserve: jest.fn() };
    
    const service = new OrderService(mockDb, mockEmail, mockInventory);
    await service.createOrder(orderData);
    
    expect(mockDb.insert).toHaveBeenCalled();
    expect(mockEmail.send).toHaveBeenCalled();
    expect(mockInventory.reserve).toHaveBeenCalled();
  });
});
```

**Problems**:
- Mocks all internal collaborators
- Tests that functions are called, not behavior
- Doesn't verify order is actually created correctly
- Would pass even if order creation is broken

### ✅ GOOD: Integration Test

```typescript
// GOOD: Tests real behavior with test database
describe('Order Creation', () => {
  let testDb;
  
  beforeEach(async () => {
    testDb = await createTestDatabase();
  });
  
  it('creates order and makes it retrievable', async () => {
    const order = await createOrder({
      userId: 'user123',
      items: [{ productId: 'prod1', quantity: 2 }],
      total: 50.00
    });
    
    expect(order.id).toBeDefined();
    expect(order.status).toBe('pending');
    
    // Verify through interface
    const retrieved = await getOrder(order.id);
    expect(retrieved.userId).toBe('user123');
    expect(retrieved.total).toBe(50.00);
  });
  
  it('reserves inventory when order created', async () => {
    const productId = 'prod1';
    const initialStock = await getStock(productId);
    
    await createOrder({
      userId: 'user123',
      items: [{ productId, quantity: 2 }]
    });
    
    const newStock = await getStock(productId);
    expect(newStock).toBe(initialStock - 2);
  });
});
```

**Why Better**:
- Tests real behavior end-to-end
- Uses test database (real integration)
- Verifies order is actually created correctly
- Would fail if order creation is broken

---

## Example 4: Form Validation (Frontend)

### ❌ BAD: Tests Validation Logic in Isolation

```typescript
// BAD: Tests extracted validation function
describe('validateEmail', () => {
  it('returns true for valid email', () => {
    expect(validateEmail('test@example.com')).toBe(true);
  });
  
  it('returns false for invalid email', () => {
    expect(validateEmail('notanemail')).toBe(false);
  });
});

describe('LoginForm', () => {
  it('calls validateEmail on submit', () => {
    const spy = jest.spyOn(validators, 'validateEmail');
    render(<LoginForm />);
    
    fireEvent.submit(screen.getByRole('button', { name: 'Login' }));
    expect(spy).toHaveBeenCalled();
  });
});
```

**Problems**:
- Tests validation logic separately from where it's used
- Tests that validation is called, not that validation works
- Doesn't test user experience (error messages, etc.)

### ✅ GOOD: Tests Form Behavior

```typescript
// GOOD: Tests form behavior as user experiences it
describe('Login Form', () => {
  it('shows error for invalid email format', async () => {
    render(<LoginForm />);
    
    await userEvent.type(screen.getByLabelText('Email'), 'notanemail');
    await userEvent.click(screen.getByRole('button', { name: 'Login' }));
    
    expect(screen.getByText('Please enter a valid email')).toBeInTheDocument();
  });
  
  it('submits form with valid email', async () => {
    const mockOnSubmit = jest.fn();
    render(<LoginForm onSubmit={mockOnSubmit} />);
    
    await userEvent.type(screen.getByLabelText('Email'), 'test@example.com');
    await userEvent.type(screen.getByLabelText('Password'), 'password123');
    await userEvent.click(screen.getByRole('button', { name: 'Login' }));
    
    expect(mockOnSubmit).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password123'
    });
  });
  
  it('disables submit button while validating', async () => {
    render(<LoginForm />);
    
    const submitButton = screen.getByRole('button', { name: 'Login' });
    await userEvent.click(submitButton);
    
    expect(submitButton).toBeDisabled();
  });
});
```

**Why Better**:
- Tests complete user experience
- Verifies error messages appear
- Tests form submission behavior
- Tests UI state changes (disabled button)

---

## Example 5: Database Operations (Backend)

### ❌ BAD: Bypasses Interface

```typescript
// BAD: Tests database directly instead of through API
describe('User Repository', () => {
  it('saves user to database', async () => {
    const repo = new UserRepository(db);
    await repo.save({ name: 'Alice', email: 'alice@example.com' });
    
    const rows = await db.query('SELECT * FROM users WHERE email = ?', ['alice@example.com']);
    expect(rows).toHaveLength(1);
    expect(rows[0].name).toBe('Alice');
  });
});
```

**Problems**:
- Queries database directly (bypassing interface)
- Tests database schema (implementation detail)
- Would need rewrite if switching databases

### ✅ GOOD: Tests Through Repository Interface

```typescript
// GOOD: Tests through public interface
describe('User Management', () => {
  it('saved user is retrievable by ID', async () => {
    const user = await userRepo.save({
      name: 'Alice',
      email: 'alice@example.com'
    });
    
    const retrieved = await userRepo.findById(user.id);
    expect(retrieved.name).toBe('Alice');
    expect(retrieved.email).toBe('alice@example.com');
  });
  
  it('can find user by email', async () => {
    await userRepo.save({ name: 'Alice', email: 'alice@example.com' });
    
    const found = await userRepo.findByEmail('alice@example.com');
    expect(found).toBeDefined();
    expect(found.name).toBe('Alice');
  });
  
  it('returns null for non-existent user', async () => {
    const found = await userRepo.findById('nonexistent');
    expect(found).toBeNull();
  });
});
```

**Why Better**:
- Tests through repository interface (public API)
- Doesn't depend on database schema
- Would work same if switching databases
- Tests actual repository behavior

---

## Pattern Recognition

### Implementation-Coupled (Bad) Patterns

```typescript
// Testing internal methods
it('_privateMethod returns X')

// Testing that functions are called
expect(mockFunction).toHaveBeenCalled()

// Testing internal state
expect(instance.state.X).toBe(Y)

// Testing through side channels
const dbRow = await db.query(...); expect(dbRow)...

// Testing mock configuration
expect(mock).toHaveBeenCalledWith(exact, args)
```

### Behavior-Focused (Good) Patterns

```typescript
// Testing observable outcomes
expect(result.status).toBe('success')

// Testing user interactions
await userEvent.click(...); expect(screen.getByText(...))

// Testing through public API
const created = await create(...); const retrieved = await get(created.id)

// Testing error cases
await expect(fn()).rejects.toThrow('Error message')

// Testing integration
const before = await getState(); await operation(); const after = await getState()
```

---

## Summary

**Good Tests**:
- Exercise code through public interfaces
- Test behavior users/callers experience
- Use integration approach where possible
- Mock only external services
- Survive refactors

**Bad Tests**:
- Test internal implementation details
- Mock internal collaborators
- Access private methods/state
- Verify through side channels
- Break on refactors

**Golden Rule**: 
> Your test should describe WHAT the code does for users,
> not HOW it accomplishes it internally.

---

**See Also**:
- [PHILOSOPHY.md](./PHILOSOPHY.md) - Why behavior vs implementation matters
- [MOCKING.md](./MOCKING.md) - When to mock (system boundaries only)
- [ANTI-PATTERNS.md](./ANTI-PATTERNS.md) - Horizontal slicing and other mistakes
