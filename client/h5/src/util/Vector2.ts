// TypeScript file
export class Vector2 {
    x: number = 0;
    y: number = 0;
    static vector_count = 0;
    public constructor(x: number | Vector2 = 0, y: number = 0) {
        if (typeof x == "number") {
            this.x = x;
            this.y = y;
        }
        else {
            this.x = x.x;
            this.y = x.y;
        }
        // ++ Vector2.vector_count
        // console.log("-----------------------------vector_count =", ++ Vector2.vector_count)
    }
    
    public normalise() {
        let l = Math.sqrt(this.x * this.x + this.y * this.y);
        if (l >= 1e-6) {
            let f = 1 / l;
            this.x = this.x * f;
            this.y = this.y * f;
        }
        return l;
    }

    public dotProduct(v2) {
        return this.x * v2.x + this.y * v2.y;
    }

    public getDir(v2: Vector2, result_v?: Vector2): Vector2 {
        if (result_v != null) {
            result_v.x = this.x - v2.x;
            result_v.y = this.y - v2.y;
            return result_v;
        }
        else {
            let v0: Vector2 = new Vector2(this.x - v2.x, this.y - v2.y);
            return v0;
        }
    }

    public static MulXYTable(t1,t2){
        return new Vector2(t1.x*t2.x ,t1.y*t2.y)
    }


    public static readonly one = new Vector2(1,1);
    public static readonly zero = new Vector2(0,0);
}

window["Vector2"] = Vector2