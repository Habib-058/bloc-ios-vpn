# BLoC Event Design Guide: When to Create Separate Events vs Combine Operations

## 🎯 Core Principle

**Create a separate event when:**
- The operation can be triggered **independently** by user actions
- The operation represents a **distinct user intent**
- The operation needs **different parameters**
- The operation should be **reusable** in different contexts

**Combine operations in one event when:**
- Operations are **always executed together** as a sequence
- Operations are part of a **single logical workflow**
- Operations represent **one user action** (e.g., "Initialize Screen")

---

## 📋 Decision Tree

```
Is this triggered by user action?
├─ YES → Create separate event
│   ├─ Button click → Separate event
│   ├─ Form submit → Separate event
│   └─ User selection → Separate event
│
└─ NO → Is this part of initialization?
    ├─ YES → Combine in OnInitEvent
    └─ NO → Is this reactive (from stream)?
        ├─ YES → Separate event (auto-emitted)
        └─ NO → Combine if related workflow
```

---

## ✅ Combine Operations in One Event (OnInitHomeEvent)

### When to Combine:

1. **Sequential operations that always run together**
   ```dart
   void _onInitHomeEvent(...) async {
     // ✅ All these run together as initialization
     await fetchInitialServer();
     await switchProtocol();
     await initializeVPN();
     await loadUserPreferences();
   }
   ```

2. **Operations that are part of a single workflow**
   ```dart
   void _onInitHomeEvent(...) async {
     // ✅ All part of "screen initialization"
     emit(state.copyWith(isLoading: true));
     await loadData();
     await setupServices();
     emit(state.copyWith(isLoading: false));
   }
   ```

3. **Operations that depend on each other**
   ```dart
   void _onInitHomeEvent(...) async {
     // ✅ Step 2 depends on Step 1
     final server = await fetchServer();
     await connectToServer(server);
   }
   ```

### ✅ Good Examples:

```dart
// ✅ GOOD: All initialization operations together
void _onInitHomeEvent(...) async {
  await initializeHomeVpnLocationUseCase();
  await homeSwitchProtocolUseCase(SupportedVpnProtocol.vmess);
  await homeInitializeVpnUseCase();
  await loadUserSettings();
  await checkPermissions();
}
```

---

## 🔀 Create Separate Events

### When to Create Separate Events:

1. **User-triggered actions** (buttons, taps, inputs)
   ```dart
   // ✅ Separate events for user actions
   class OnConnectVpnEvent extends HomeScreenEvent {}
   class OnDisconnectVpnEvent extends HomeScreenEvent {}
   class OnSelectServerEvent extends HomeScreenEvent {
     final ServerModel server;
   }
   ```

2. **Operations that can be triggered independently**
   ```dart
   // ✅ User can switch protocol without initializing
   class OnSwitchProtocolEvent extends HomeScreenEvent {
     final SupportedVpnProtocol protocol;
   }
   
   // ✅ User can select server independently
   class OnSelectServerEvent extends HomeScreenEvent {
     final ServerModel server;
   }
   ```

3. **Reactive updates from streams** (auto-emitted)
   ```dart
   // ✅ Automatically emitted by stream listeners
   class OnVpnStageChangedEvent extends HomeScreenEvent {
     final CapVPNConnectionStage stage;
   }
   
   class OnVpnStatusChangedEvent extends HomeScreenEvent {
     final CapVPNConnectionStatus status;
   }
   ```

4. **Operations with different parameters**
   ```dart
   // ✅ Different parameters = different events
   class OnSearchServersEvent extends HomeScreenEvent {
     final String query;
   }
   
   class OnFilterServersEvent extends HomeScreenEvent {
     final ServerFilter filter;
   }
   ```

### ✅ Good Examples:

```dart
// ✅ GOOD: Separate events for independent actions
class OnConnectVpnEvent extends HomeScreenEvent {}
class OnDisconnectVpnEvent extends HomeScreenEvent {}
class OnSelectServerEvent extends HomeScreenEvent {
  final ServerModel server;
}
class OnSwitchProtocolEvent extends HomeScreenEvent {
  final SupportedVpnProtocol protocol;
}
```

---

## ❌ Common Mistakes

### ❌ Mistake 1: Creating events for operations that always run together

```dart
// ❌ BAD: These always run together
class OnFetchServerEvent extends HomeScreenEvent {}
class OnSwitchProtocolEvent extends HomeScreenEvent {}
class OnInitVpnEvent extends HomeScreenEvent {}

// ✅ GOOD: Combine them
class OnInitHomeEvent extends HomeScreenEvent {}
void _onInitHomeEvent(...) async {
  await fetchServer();
  await switchProtocol();
  await initVpn();
}
```

### ❌ Mistake 2: Combining independent user actions

```dart
// ❌ BAD: User might want to connect without selecting server
class OnConnectWithServerEvent extends HomeScreenEvent {
  final ServerModel server;
}

// ✅ GOOD: Separate events
class OnSelectServerEvent extends HomeScreenEvent {
  final ServerModel server;
}
class OnConnectVpnEvent extends HomeScreenEvent {}
```

### ❌ Mistake 3: Not separating reactive updates

```dart
// ❌ BAD: Trying to handle stream updates in OnInitEvent
void _onInitHomeEvent(...) {
  VpnService().stageStream.listen((stage) {
    // ❌ This won't work - can't emit from here
  });
}

// ✅ GOOD: Separate event for stream updates
class OnVpnStageChangedEvent extends HomeScreenEvent {
  final CapVPNConnectionStage stage;
}
```

---

## 📊 Real-World Examples

### Example 1: Home Screen Initialization

```dart
// ✅ Combine: All initialization operations
class OnInitHomeEvent extends HomeScreenEvent {}

void _onInitHomeEvent(...) async {
  await fetchInitialServer();      // ✅ Part of init
  await switchProtocol();          // ✅ Part of init
  await initializeVPN();           // ✅ Part of init
  await loadUserPreferences();     // ✅ Part of init
}
```

### Example 2: User Actions

```dart
// ✅ Separate: Independent user actions
class OnConnectVpnEvent extends HomeScreenEvent {}
class OnDisconnectVpnEvent extends HomeScreenEvent {}
class OnSelectServerEvent extends HomeScreenEvent {
  final ServerModel server;
}
class OnSwitchProtocolEvent extends HomeScreenEvent {
  final SupportedVpnProtocol protocol;
}
```

### Example 3: Reactive Updates

```dart
// ✅ Separate: Auto-emitted by streams
class OnVpnStageChangedEvent extends HomeScreenEvent {
  final CapVPNConnectionStage stage;
}
class OnVpnStatusChangedEvent extends HomeScreenEvent {
  final CapVPNConnectionStatus status;
}
```

---

## 🎯 Quick Reference

| Operation Type | Event Strategy | Example |
|---------------|----------------|---------|
| **Screen initialization** | Combine in `OnInitEvent` | Fetch data, setup services |
| **User button click** | Separate event | `OnConnectVpnEvent` |
| **User input/selection** | Separate event | `OnSelectServerEvent` |
| **Stream updates** | Separate event | `OnVpnStageChangedEvent` |
| **Sequential workflow** | Combine in one event | Login → Load data → Setup |
| **Independent actions** | Separate events | Connect, Disconnect, Select |

---

## 💡 Best Practices

1. **Start with combined events** for initialization
2. **Create separate events** when user can trigger them independently
3. **Always separate** reactive updates (streams)
4. **Group related operations** that always run together
5. **Keep events focused** - one event = one user intent

---

## 🔍 Your Current Implementation Analysis

### ✅ What You Did Right:

```dart
// ✅ GOOD: Combined initialization operations
void _onInitHomeEvent(...) async {
  await initializeHomeVpnLocationUseCase();
  await homeSwitchProtocolUseCase(...);
  await homeInitializeVpnUseCase();
}

// ✅ GOOD: Separate events for stream updates
class OnVpnStageChangedEvent extends HomeScreenEvent {}
class OnVpnStatusChangedEvent extends HomeScreenEvent {}
```

### 💡 What You Could Add:

```dart
// 💡 Consider adding separate events for user actions:
class OnConnectVpnEvent extends HomeScreenEvent {}
class OnDisconnectVpnEvent extends HomeScreenEvent {}
class OnSelectServerEvent extends HomeScreenEvent {
  final ServerModel server;
}
```

---

## 📝 Summary

**Combine in OnInitEvent:**
- ✅ Initialization operations
- ✅ Sequential workflows
- ✅ Operations that always run together

**Create Separate Events:**
- ✅ User-triggered actions
- ✅ Independent operations
- ✅ Reactive updates (streams)
- ✅ Operations with different parameters

**Remember:** One event = One user intent or one reactive update

