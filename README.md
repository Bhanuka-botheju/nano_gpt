# 🤖 GPT from Scratch — Transformer Language Model

A character-level language model built from scratch in PyTorch, inspired by the paper **["Attention Is All You Need"](https://arxiv.org/abs/1706.03762)** by Vaswani et al. Trained on the Tiny Shakespeare dataset to generate Shakespeare-like text.

---

## 📖 About

This project is my hands-on implementation to deeply understand how the **Transformer architecture** works under the hood — including self-attention, multi-head attention, positional embeddings, and layer normalization — without relying on high-level abstractions.

The model learns to predict the next character in a sequence, and after training it can generate new Shakespeare-style text.

---
![Model Architecture](src/Your%20paragraph%20text.jpg)
---

## 🧠 Architecture Overview

The model is a **decoder-only Transformer** (similar to GPT), consisting of:

| Component | Details |
|---|---|
| **Token Embedding** | Maps characters to vectors of size `n_embd = 384` |
| **Positional Embedding** | Learned positional encodings up to `block_size = 256` |
| **Transformer Blocks** | 6 stacked blocks, each with Self-Attention + Feed-Forward |
| **Self-Attention Heads** | 6 heads, each of size `n_embd / n_head = 64` |
| **Feed-Forward Network** | 2-layer MLP with 4× expansion and ReLU activation |
| **Layer Normalization** | Custom `LayerNorm1d` applied before each sub-layer (Pre-Norm) |
| **Dropout** | Rate of `0.2` for regularization |
| **Output Head** | Linear layer projecting to `vocab_size` for next-token prediction |

### Key Concepts Implemented

- **Scaled Dot-Product Attention** — `QKᵀ / √dₖ` with causal masking
- **Multi-Head Attention** — Multiple attention heads computed in parallel and concatenated
- **Residual (Skip) Connections** — `x = x + SubLayer(x)` in every block
- **Pre-Layer Normalization** — LayerNorm applied before attention and FFN (more stable training)
- **Autoregressive Generation** — Next token sampled from softmax probability distribution

---

## ⚙️ Hyperparameters

```python
batch_size   = 64      # Sequences processed in parallel
block_size   = 256     # Maximum context length (sequence length)
max_iters    = 5000    # Training iterations
learning_rate = 3e-4   # AdamW optimizer learning rate
n_embd       = 384     # Embedding dimension
n_head       = 6       # Number of attention heads
n_layer      = 6       # Number of Transformer blocks
dropout      = 0.2     # Dropout rate
```

---

## 📂 Project Structure

```
├── gpt.py                  # Main model and training script
├── tiny_shakespeare.txt    # Training data (Tiny Shakespeare dataset)
└── README.md               # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites

```bash
pip install torch
```

### Download the Dataset

```bash
wget https://raw.githubusercontent.com/karpathy/char-rnn/master/data/tinyshakespeare/input.txt -O tiny_shakespeare.txt
```

### Run Training

```bash
python gpt.py
```

Training will print loss every 500 steps and generate a sample of 500 characters at the end.

---

## 📊 Training

The model is trained using **cross-entropy loss** on character-level next-token prediction. Loss is evaluated on both train and validation splits every `eval_interval = 500` steps.

Example training output:
```
step 0:    train loss 4.2241, val loss 4.2306
step 500:  train loss 2.0341, val loss 2.1072
step 1000: train loss 1.7943, val loss 1.9401
...
step 4500: train loss 1.4823, val loss 1.7082
```

---

## ✍️ Sample Generated Text

After training, the model generates character sequences in Shakespeare's style:

```
GLOUCESTER:
O, that I were as great as my grief, or lesser than
my name, or some of both! I would give all to be gone.

KING RICHARD III:
Away with me, all you whose souls abhor
Th' uncleanly savours of a slaughter-house...
```

---

## 📚 References

- [Attention Is All You Need — Vaswani et al., 2017](https://arxiv.org/abs/1706.03762)
- [Let's build GPT — Andrej Karpathy (YouTube)](https://www.youtube.com/watch?v=kCc8FmEb1nY)
- [nanoGPT — Andrej Karpathy (GitHub)](https://github.com/karpathy/nanoGPT)
- [The Annotated Transformer — Harvard NLP](https://nlp.seas.harvard.edu/2018/04/03/attention.html)

---

## 🙋 Author

Built as a learning project to understand the Transformer architecture from first principles.

Feel free to ⭐ star the repo if you found it helpful!
