# Gamma Cipher (OTP) Compute Engines

The concept of a gamma cipher, also known as OTP, implemented using SIMD instructions on CPUs and GPUs.

This proof-of-concept allows us to test the performance of Apple's A/M-Series SoCs, as it uses NEON instructions for the CPU implementation and the Metal API for the GPU implementation.

Both implementations utilize a zero-copy memory mechanism.

CPU and GPU performance, as well as memory bandwidth, directly impact processing speed.

| CPU Compute Engine  | GPU Compute Engine |
| ------------- | ------------- |
| <img width="612" height="518" alt="Screenshot 2025-11-28 at 10 05 20 PM" src="https://github.com/user-attachments/assets/7c85e8c0-7fb7-48cc-8f66-608d2774b63c" /> | <img width="612" height="518" alt="Screenshot 2025-11-28 at 10 05 34 PM" src="https://github.com/user-attachments/assets/5058fd1e-97a2-4777-ae5c-b6df5ad23901" /> |
