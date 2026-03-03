# 🤖 GPT from Scratch — Transformer Language Model

A character-level language model built from scratch in PyTorch, inspired by the paper **["Attention Is All You Need"](https://arxiv.org/abs/1706.03762)** by Vaswani et al. Trained on the Tiny Shakespeare dataset to generate Shakespeare-like text.

The model is wrapped in a **Flask REST API**, containerized with **Docker**, and deployed to **Google Cloud Run** with a fully automated **GitHub Actions CI/CD pipeline**.

---

## 📖 About

This project is my hands-on implementation to deeply understand how the **Transformer architecture** works under the hood — including self-attention, multi-head attention, positional embeddings, and layer normalization — without relying on high-level abstractions.

The model learns to predict the next character in a sequence, and after training it can generate new Shakespeare-style text via a live REST API endpoint.

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
├── gpt.py                      # Main model and training script
├── app.py                      # Flask REST API
├── pyproject.toml              # uv project dependencies
├── uv.lock                     # Locked dependency versions
├── Dockerfile                  # Container definition
├── tiny_shakespeare.txt        # Training data (Tiny Shakespeare dataset)
├── shakespeare_transformer.pth # Trained model weights
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions CI/CD pipeline
└── README.md                   # Project documentation
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

## 🌐 REST API

The trained model is served via a **Flask REST API**.

### Endpoints

| Method | Route | Description |
|---|---|---|
| `GET` | `/` | Health check — confirms the API is running |
| `POST` | `/generate` | Generate Shakespeare-style text from a prompt |

### Request Body (`/generate`)

```json
{
  "prompt": "To be, or not to be, ",
  "max_tokens": 150
}
```

### Response

```json
{
  "status": "success",
  "output": "To be, or not to be, that is the question..."
}
```

### Example — curl

```bash
curl -X POST https://YOUR_CLOUD_RUN_URL/generate \
     -H "Content-Type: application/json" \
     -d '{"prompt": "O Romeo, ", "max_tokens": 100}'
```

### Example — Python

```python
import requests

url = "https://YOUR_CLOUD_RUN_URL/generate"
payload = {"prompt": "O Romeo, ", "max_tokens": 100}

response = requests.post(url, json=payload)
print(response.json())
```

---

## 🐳 Docker

The application is containerized using **Docker** with [`uv`](https://github.com/astral-sh/uv) for fast, reproducible dependency management.

```bash
# Build the image
docker build -t shakespeare-gpt .

# Run locally
docker run -p 5000:5000 shakespeare-gpt
```

The Dockerfile uses `uv sync --frozen --no-dev` with the `pyproject.toml` and `uv.lock` files to ensure exact dependency versions across all environments. PyTorch is pulled from the **CPU-only index** to keep the image lightweight.

---

## ☁️ Deployment — Google Cloud Run

The API is deployed on **Google Cloud Run** (serverless, auto-scaling).

### Infrastructure

| Component | Details |
|---|---|
| **Container Registry** | Google Artifact Registry |
| **Hosting** | Google Cloud Run |
| **Region** | `us-central1` |
| **Memory** | 2GB (required for loading PyTorch model) |
| **Access** | Public (unauthenticated) |

### CI/CD Pipeline — GitHub Actions

Every push to the `main` branch automatically:

1. Builds the Docker image
2. Pushes it to Google Artifact Registry
3. Deploys the new revision to Cloud Run

```
git push origin main
       │
       ▼
  GitHub Actions
       │
       ├─ docker build
       ├─ docker push → Artifact Registry
       └─ gcloud run deploy → Cloud Run ✅
```

GCP credentials are stored as a GitHub repository secret (`GCP_CREDENTIALS`) and never exposed in the codebase.

---

## 📚 References

- [Attention Is All You Need — Vaswani et al., 2017](https://arxiv.org/abs/1706.03762)
- [Let's build GPT — Andrej Karpathy (YouTube)](https://www.youtube.com/watch?v=kCc8FmEb1nY)
- [nanoGPT — Andrej Karpathy (GitHub)](https://github.com/karpathy/nanoGPT)
- [The Annotated Transformer — Harvard NLP](https://nlp.seas.harvard.edu/2018/04/03/attention.html)
- [uv — Astral](https://github.com/astral-sh/uv)
- [Google Cloud Run Documentation](https://cloud.google.com/run/docs)

---

## 🙋 Author

Built as a learning project to understand the Transformer architecture from first principles — and to practice deploying ML models in a production-style cloud environment.

Feel free to ⭐ star the repo if you found it helpful!