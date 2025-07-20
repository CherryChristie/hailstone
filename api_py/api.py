from fastapi import FastAPI, Query, HTTPException
from hailstone_py.hailstone import calculate_hailstone, finalize_sequence

app = FastAPI(title="Hailstone Sequence API")

@app.get("/hailstone")
def get_hailstone(start: int = Query(..., gt=0, description="Starting number")):
    try:
        sequence =calculate_hailstone(start)
        return {
            "start": start,
            "steps": len(sequence) - 1,
            "sequence": sequence,
            "summary": finalize_sequence(sequence)
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
