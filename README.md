# Lustre Server Component Example

## Build and Run

### Using Docker

```
docker compose up
```

### Local

Build the client:
```
cd client
gleam run -m lustre/dev build --no-html --outdir=../server/priv/static/

```
Start the server:
```
cd server
gleam run
```


Open [http://localhost:8100](http://localhost:8100)

