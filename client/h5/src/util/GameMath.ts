import { Vector2 } from "./Vector2";
import { Util } from "./Util";
// TypeScript file
let local_Vector2 = Vector2
export class GameMath {
    static DirNum = [1, 3, 7, 9];
    public static GetDistance(p1x, p1y, p2x, p2y, need_sqrt: Boolean = false) {
        let x_step = p1x - p2x;
        let y_step = p1y - p2y;
        let val = x_step * x_step + y_step * y_step;
        if (need_sqrt) {
            return Math.pow(val, 0.5);
        }
        return val;
    }

    public static GetDistance3D(p1x, p1y, p1z, p2x, p2y, p2z, need_sqrt: Boolean = false) {
        let x_step = p1x - p2x;
        let y_step = p1y - p2y;
        let z_step = p1z - p2z;
        let val = x_step * x_step + y_step * y_step + z_step * z_step;
        if (need_sqrt) {
            return Math.pow(val, 0.5);
        }
        return val;
    }

    public static IsPointNear(p1x, p1y, p2x, p2y, near_val: number = 1) {
        let x_step = p1x - p2x;
        let y_step = p1y - p2y;
        let val = x_step * x_step + y_step * y_step;
        return val <= near_val * near_val;
    }
    public static AngleToVector(angle: number) {
        let radian = angle * Math.PI / 180;
        return new local_Vector2(Math.cos(radian), Math.sin(radian));
    }
    public static VectorToAngle(vector: Vector2) {
        if (vector.x == 0) {
            if (vector.y > 0) {
                return 90;
            }
            else {
                return 270;
            }
        }
        else {
            let angle = Math.abs(Math.atan(vector.y / vector.x) * 180 / Math.PI);
            if (vector.y <= 0 && vector.x > 0) {
                return 360 - angle;
            }
            else if (vector.y <= 0 && vector.x < 0) {
                return 180 + angle;
            }
            else if (vector.y >= 0 && vector.x < 0) {
                return 180 - angle;
            }
            else if (vector.y >= 0 && vector.x > 0) {
                return angle;
            }
        }
    }
    public static DirNumToVector(dir_num: number, result_vec: Vector2 = null) {
        if (dir_num == 1) {
            if (result_vec) {
                result_vec.x = -0.71;
                result_vec.y = 0.71;
                return result_vec;
            }
            else
                return new local_Vector2(-0.71, 0.71);
        }
        else if (dir_num == 2) {
            if (result_vec) {
                result_vec.x = 0;
                result_vec.y = 1;
                return result_vec;
            }
            else
                return new local_Vector2(0, 1);
        }
        else if (dir_num == 3) {
            if (result_vec) {
                result_vec.x = 0.71;
                result_vec.y = 0.71;
                return result_vec;
            }
            else
                return new local_Vector2(0.71, 0.71);
        }
        else if (dir_num == 9) {
            if (result_vec) {
                result_vec.x = 0.71;
                result_vec.y = -0.71;
                return result_vec;
            }
            else
                return new local_Vector2(0.71, -0.71);
        }
        else if (dir_num == 7) {
            if (result_vec) {
                result_vec.x = -0.71;
                result_vec.y = -0.71;
                return result_vec;
            }
            else
                return new local_Vector2(-0.71, -0.71);
        }
    }
    public static VectorToDirNum(vec: Vector2) {
        if (vec) {
            let dir_number;
            if (vec.x >= 0 && vec.y >= 0) {
                dir_number = 3;
            }
            else if (vec.x >= 0 && vec.y <= 0) {
                dir_number = 9;
            }
            else if (vec.x <= 0 && vec.y <= 0) {
                dir_number = 7;
            }
            else if (vec.x <= 0 && vec.y >= 0) {
                dir_number = 1;
            }
            return dir_number;
        }
        return 3;
    }
    public static DistancePointToLine(dir, pos, need_sqrt = false) {
        let x0 = pos.x; //目标点相对于直线起点的相对坐标
        let y0 = pos.y; //目标点相对于直线起点的相对坐标
        let A = dir.y; //直线方程的系数
        let B = -dir.x; //直线方程的系数
        let d1 = (A * x0 + B * y0);
        let d = (d1 * d1) / (A * A + B * B); //目标点和直线的距离的平方
        if (need_sqrt)
            d = Math.pow(d, 0.5);
        return d;
    }
    //获取以center_x center_y为远点 radii为半径的圆圈上的随机一点
    public static GetRandomPos(center_x: number, center_y: number, radii: number) {
        let vec = new local_Vector2();
        let radian = Util.RandomRange(0, 360) * Math.PI / 180;
        vec.x = center_x + radii * Math.cos(radian);
        vec.y = center_y + radii * Math.sin(radian);
        return vec;
    }
    //随机方向
    public static GetRandomDirNum() {
        return GameMath.DirNum[Math.floor(Math.random() * 4)];
    }
    //把正圆的值转化成椭圆不同方向的值
    public static ChangeEllipseValue(dir, value, ratio?, type?){
        if(dir){
            ratio = ratio || 0.5
            let radian = 0
            if(dir.x == 0){
                if(dir.y > 0)
                    radian = 90 / 180 * Math.PI
                else if(dir.y == 0)
                    radian = 0
                else if(dir.y < 0)
                    radian = -270 / 180 * Math.PI
                
            }
            else
                radian = Math.atan(dir.y / dir.x) //先计算夹角
    
            let func = null
            if(type == null || type == 1) //1为x方向较长  2 为y方向较长的椭圆
                func = Math.cos
            else
                func = Math.sin
    
            //椭圆处理
            return value * ratio + Math.abs(func(radian)) * value * (1 - ratio)
        }
	    else
		    return value
    }

    public static LerpXYZ(from,to,t) {
        let x = GameMath.Lerp(from.x,to.x,t)
        let y = GameMath.Lerp(from.y,to.y,t)
        let z = GameMath.Lerp(from.z,to.z,t)
        return  new Laya.Point(x,y)//  to.TableXYZ(x,y,z)
    }

    public static Lerp(from,to,t) { 
        if (t > 1 ) {
            t = 1
        } else if (t < 0 ) {
            t = 0
        }
        let delta = to - from
        return from + delta * t
    }
    
}

window["GameMath"] = GameMath