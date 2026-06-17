# Design Review Template

**How to Use**: This template is filled by the Architect during `/design` workflow, capturing design decisions and implementation planning.

**When**: After requirements gathering, before implementation  
**Updated By**: Architect agent  
**Referenced In**: `.ai/workflows/design.md`, implementation tasks

---

## Summary

**What Goes Here**: High-level overview of what's being designed

**Format**:
```
**Feature**: {Name of feature/change}  
**Requester**: {Who requested this}  
**Goal**: {What problem does this solve}  
**Scope**: {What's included/excluded}  
**Approach**: {High-level solution approach}  
```

**Example**:
```
**Feature**: Partial Order Cancellation  
**Requester**: Product team (user feedback)  
**Goal**: Allow customers to cancel individual items instead of entire order  
**Scope**: 
- IN: Cancel LineItems from pending orders, automatic refunds
- OUT: Cancel after shipment, partial shipment cancellation
**Approach**: Add cancellable flag to LineItem, refund via payment gateway API
```

---

## PRD Changes

**What Goes Here**: Updates to Product Requirements Document based on design decisions

**Format**:
```
### Change {N}: {What changed}
**Reason**: {Why this change needed}  
**Impact**: {What's affected}  
**Status**: {Accepted/Pending/Rejected}  
```

**Example**:
```
### Change 1: Added "cancellation window" constraint
**Reason**: Payment processing takes time, can't cancel during processing  
**Impact**: Adds business rule: "Cancellable only when status = 'pending'"  
**Status**: Accepted  

### Change 2: Removed "partial shipment cancellation"  
**Reason**: Logistics complexity too high for V1  
**Impact**: Scope reduced, but simpler implementation  
**Status**: Accepted  
```

**If no changes**: State "No PRD changes needed"

---

## Architecture Changes

**What Goes Here**: How system architecture will change to support this feature

**Format**:
```
### Component: {Name}
**Change**: {What changes in this component}  
**Reason**: {Why this change}  
**Impact**: {Downstream effects}  
**Dependencies**: {What this depends on}  
```

**Example**:
```
### Component: Order Service
**Change**: Add `cancelLineItems(orderId, lineItemIds[])` method  
**Reason**: Need atomic operation for partial cancellation  
**Impact**: Requires transaction to ensure order totals stay consistent  
**Dependencies**: Payment Service (for refund), Inventory Service (restock)  

### Component: Payment Service  
**Change**: Add `refundPartial(orderId, amount, lineItemIds[])` method  
**Reason**: Existing `refund()` only handles full order refunds  
**Impact**: New method, backward compatible  
**Dependencies**: Payment gateway API  

### Component: Database Schema  
**Change**: Add `cancelled_at` timestamp to line_items table  
**Reason**: Track when each item cancelled (audit trail)  
**Impact**: Migration needed, indexes on cancelled_at for queries  
**Dependencies**: None  
```

**If no architecture changes**: State "No architecture changes (pure feature add/bug fix)"

---

## Implementation Plan

**What Goes Here**: Step-by-step plan for building this feature

**Format**:
```
### Phase {N}: {Phase name}
**Tasks**:
1. {Task description} - {Estimated effort} - {Owner}
2. {Task description} - {Estimated effort} - {Owner}

**Dependencies**: {What must complete before this phase}  
**Outcome**: {What's delivered}  
**Risks**: {What could go wrong}  
```

**Example**:
```
### Phase 1: Database Changes
**Tasks**:
1. Create migration for line_items.cancelled_at column - 30min - Backend
2. Add indexes on cancelled_at and (order_id, cancelled_at) - 15min - Backend
3. Update LineItem model with cancellation fields - 30min - Backend

**Dependencies**: None (can start immediately)  
**Outcome**: Database schema ready for cancellation feature  
**Risks**: Migration fails on production (test on staging first)  

### Phase 2: Backend Implementation
**Tasks**:
1. Implement OrderService.cancelLineItems() with TDD - 4h - Backend
2. Implement PaymentService.refundPartial() with TDD - 3h - Backend
3. Add cancellation business rules validation - 2h - Backend
4. Integration tests for cancel flow - 2h - Backend

**Dependencies**: Phase 1 complete  
**Outcome**: Backend API ready, tested  
**Risks**: Payment gateway refund API might fail (add retry logic)  

### Phase 3: Frontend Implementation  
**Tasks**:
1. Add "Cancel Item" button to OrderDetails component - 2h - Frontend
2. Add confirmation modal for cancellation - 1h - Frontend
3. Update order totals after cancellation - 1.5h - Frontend
4. E2E tests for cancel flow - 2h - QA

**Dependencies**: Phase 2 complete  
**Outcome**: Feature complete, ready for UAT  
**Risks**: UI/UX might need iteration based on user feedback  
```

---

## Risks

**What Goes Here**: Potential issues and mitigation strategies

**Format**:
```
### Risk {N}: {Risk description}
**Probability**: {High/Medium/Low}  
**Impact**: {High/Medium/Low}  
**Mitigation**: {How to reduce/handle}  
**Owner**: {Who monitors this}  
```

**Example**:
```
### Risk 1: Payment gateway refund failures
**Probability**: Medium (external API, can timeout)  
**Impact**: High (customer not refunded, support tickets)  
**Mitigation**: 
- Implement retry logic (3 attempts with exponential backoff)
- Queue failed refunds for manual processing
- Alert admin on permanent failures
**Owner**: Backend team  

### Risk 2: Race condition in partial cancellation
**Probability**: Low (rare concurrent cancels)  
**Impact**: Medium (incorrect order totals)  
**Mitigation**: 
- Use database transaction with row locking
- Add integration test for concurrent cancellation
**Owner**: Backend team  

### Risk 3: User confusion about "pending" vs "processing"
**Probability**: High (terminology unclear to users)  
**Impact**: Low (support tickets, not system failure)  
**Mitigation**: 
- Use customer-friendly terms in UI ("preparing order" vs "pending")
- Add tooltip explaining when cancellation is possible
**Owner**: Frontend + Product  
```

---

## Human Approval

**What Goes Here**: Required approvals and status

**Format**:
```
**Required Approvals**:
- [ ] Product Owner (business logic validation)
- [ ] Tech Lead (architecture review)
- [ ] Security Team (if security-sensitive)
- [ ] Compliance (if compliance-sensitive)

**Status**: {Pending/Approved/Changes Requested}  
**Approved By**: {Name, Date}  
**Comments**: {Any approval conditions or notes}  
```

**Example**:
```
**Required Approvals**:
- [x] Product Owner (business logic validation) - Jane, 2026-06-15
- [x] Tech Lead (architecture review) - John, 2026-06-16
- [ ] Security Team (payment refunds are security-sensitive)

**Status**: Pending (awaiting Security team review)  
**Approved By**: Product: Jane (2026-06-15), Tech: John (2026-06-16)  
**Comments**: 
- Product: "Approved with condition: Add analytics for cancellation reasons"
- Tech: "Approved. Ensure retry logic for payment gateway."
- Security: (pending)
```

---

## Design Review Checklist

Before finalizing design:

### Completeness
- [ ] All requirements addressed
- [ ] Edge cases identified
- [ ] Error handling planned
- [ ] Performance considered

### Feasibility
- [ ] Technical approach validated
- [ ] Dependencies identified
- [ ] Effort estimated
- [ ] Timeline realistic

### Architecture
- [ ] Follows existing patterns
- [ ] No unnecessary complexity
- [ ] Scalable design
- [ ] Testable design

### Risks
- [ ] Risks identified
- [ ] Mitigations planned
- [ ] Owners assigned
- [ ] Monitoring planned

### Alignment
- [ ] PRD changes documented
- [ ] Architecture changes documented
- [ ] Implementation plan clear
- [ ] Human approvals obtained

---

## Integration with Workflows

**Created By**: `/design` workflow (Architect agent)  
**Triggers**: Implementation tasks (via `/build`)  
**Updates**: `.ai/context/ARCHITECTURE.md`, `docs/adr/` (if ADR-worthy)  
**Blocks**: Implementation if approval not obtained  

---

## Related Files

- `.ai/workflows/design.md` - Design workflow
- `.ai/skills/grill-with-docs/` - Design interview skill
- `.ai/context/DECISIONS.md` - Decision log
- `docs/adr/` - Architecture Decision Records

---

**Template Version**: 2.0  
**Last Updated**: 17 Juni 2026
