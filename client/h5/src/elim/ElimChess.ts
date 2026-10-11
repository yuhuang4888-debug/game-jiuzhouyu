import { BaseClass } from "../common/BaseClass"
import { ElimChessBuff } from "./ElimChessBuff"

/**旗子的特效会在这里注册 */
export class ElimChess extends BaseClass {
    buff:ElimChessBuff
    chess_type

    public constructor(chess_type?, buff_type?) {
        super()

        this.chess_type = chess_type
        if (buff_type) {
            this.buff = new ElimChessBuff(buff_type)
        }
    }

    public SetChessType(chess_type?) {

        this.chess_type = chess_type
    }

    /*
        f的时候再加管理器
    */
    public SetBuff(buff?) {

        this.buff = buff
    }

    public TriggerBuff(x?, y?,chess_type?) {

        if (this.buff) {
            this.buff.TriggerBuff(x, y,chess_type)
        }
    }

    public HasBuff() {

        return this.buff != null
    }

    public GetBuffType() {

        if (this.buff) {
            return this.buff.buff_type
        }
        return null
    }

    public GetBuffValue() {

        if (this.buff) {
            return this.buff.value
        }
        return null
    }

    public OnReset() {

        this.buff = null
    }
}