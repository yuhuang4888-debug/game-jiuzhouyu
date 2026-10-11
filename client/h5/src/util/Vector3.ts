import { Mathf } from "./Mathf";

// TypeScript file
export class Vector3 {
    x: number = 0;
    y: number = 0;
    z: number = 0;
    public constructor(x: number = 0, y: number = 0, z: number = 0) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public normalise() {
        let l = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
        if (l >= 1e-6) {
            let f = 1 / l;
            this.x = this.x * f;
            this.y = this.y * f;
            this.z = this.z * f;
        }
        return l;
    }

    public static readonly one = new Vector3(1,1,1);
    public static readonly zero = new Vector3(0,0,0);
    public static readonly up = new Vector3(0,1,0);

    public static Lerp(from, to, t){
        t = Mathf.Clamp(t, 0, 1)
	    return new Vector3(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t)
    }
}

window["Vector3"] = Vector3