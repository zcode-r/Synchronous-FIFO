# Parameterized Synchronous FIFO in Verilog

## Overview

This project implements a **parameterized synchronous FIFO (First-In First-Out) buffer** in Verilog HDL.

The FIFO supports configurable data width and depth, along with status flags for:

* Full Detection
* Empty Detection
* Overflow Detection
* Underflow Detection

A comprehensive testbench was developed to verify FIFO functionality under normal and corner-case operating conditions.

---

## Features

* Parameterized FIFO Width and Depth
* Single Clock (Synchronous FIFO)
* FIFO Occupancy Tracking using `fifo_count`
* Full Flag Generation
* Empty Flag Generation
* Overflow Detection
* Underflow Detection
* Pointer Wraparound Support
* Verilog Testbench for Functional Verification

---

## FIFO Architecture

The design consists of:

* FIFO Memory Array
* Write Pointer (`w_ptr`)
* Read Pointer (`r_ptr`)
* FIFO Occupancy Counter (`fifo_count`)
* Status Flag Logic

```text
                +----------------+
Write Data ---> |                |
Write Enable -->|                |
                |   FIFO RAM     |----> Read Data
Read Enable --->|                |
                +----------------+
                       |
                       |
          +-------------------------+
          | Status Flag Generation  |
          | Full / Empty            |
          | Overflow / Underflow    |
          +-------------------------+
```

---

## Parameters

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| WIDTH     | Data Width  | 8       |
| DEPTH     | FIFO Depth  | 8       |

Example:

```verilog
sync_fifo #(
    .WIDTH(8),
    .DEPTH(8)
) uut (...);
```

---

## FIFO Operations

### Write Operation

Data is written when:

```text
w_en = 1
AND
FIFO is not full
```

The write pointer advances after a successful write.

---

### Read Operation

Data is read when:

```text
r_en = 1
AND
FIFO is not empty
```

The read pointer advances after a successful read.

---

## Status Flags

### Empty Flag

Asserted when:

```text
fifo_count == 0
```

Indicates that no data is available to read.

---

### Full Flag

Asserted when:

```text
fifo_count == DEPTH
```

Indicates that no additional data can be written.

---

### Overflow Flag

Asserted when:

```text
Write attempted while FIFO is full
```

---

### Underflow Flag

Asserted when:

```text
Read attempted while FIFO is empty
```

---

## Verification

The testbench verifies the following scenarios:

### Test 1 – Normal FIFO Operation

* Write data into FIFO
* Read data back
* Verify FIFO ordering

Expected:

```text
1 → 2 → 3 → 4 → ...
```

---

### Test 2 – FIFO Full Condition

* Fill FIFO completely
* Verify `full` flag assertion

---

### Test 3 – Overflow Condition

* Attempt write when FIFO is already full
* Verify `overflow` flag assertion

---

### Test 4 – FIFO Empty Condition

* Read all stored entries
* Verify `empty` flag assertion

---

### Test 5 – Underflow Condition

* Attempt read from an empty FIFO
* Verify `underflow` flag assertion

---

### Test 6 – Pointer Wraparound

* Perform partial reads
* Continue writing new data
* Verify correct FIFO behavior after pointer wraparound

---

## Simulation Tools

The design was verified using:

* Icarus Verilog
* GTKWave

Waveforms were analyzed to verify:

* Pointer movement
* FIFO occupancy
* Full/Empty status
* Overflow/Underflow behavior
* Correct FIFO ordering

---

## Key Concepts Demonstrated

* Sequential Logic Design
* Synchronous FIFOs
* Circular Buffer Implementation
* Pointer Management
* FIFO Occupancy Tracking
* Status Flag Generation
* RTL Verification
* Verilog Testbench Development

---
