import { BaseClass } from "../common/BaseClass"
import { ElimChess } from "./ElimChess"
import { ElimDefine } from "./ElimDefine"


/**旗子管理类*/
export class ElimBlock extends BaseClass {
    chess:ElimChess
    tmp_reset_x
    tmp_reset_y
    x
    y
    BlockType = ElimDefine.BlockType

    public constructor(x?, y?) {
        super()

        this.SetPos(x, y)
    }

    public SetChess(chess?) {

        this.chess = chess
    }

    public GetChess():ElimChess {

        return this.chess
    }

    public ReplaceChess(chess?) {

        let old_chess = this.chess
        this.chess = chess
        return old_chess
    }

    public SetPos(x?, y?) {

        this.x = x
        this.y = y
    }

    public SetResetPos(x?, y?) {

        this.tmp_reset_x = x
        this.tmp_reset_y = y
    }

    public Shuffle(new_x?, new_y?) {

        this.SetResetPos(this.x, this.y)
        this.SetPos(new_x, new_y)
    }

    public GetChessType() {

        if (!this.chess) {
            return this.BlockType.None
        }
        return this.chess.chess_type
    }

    public HasChess() {

        return this.chess != null
    }

    public RemoveChess() {

        let chess = this.chess
        this.SetChess(null)
        if (chess) {
            chess.TriggerBuff(this.x, this.y, chess.chess_type)
        }
    }


    public AddChess(chess?) {

        this.SetChess(chess)
    }

    public TriggerBuff(op_chess_type?) {

        if (this.chess && this.chess.buff) {
            if (this.chess.buff) {
                this.chess.buff.TriggerBuff(this.x, this.y, op_chess_type)
            }
        }
    }

    public HasBuff() {

        return this.chess && this.chess.buff
    }

    public GetBuffType() {

        return this.chess && this.chess.GetBuffType() || null
    }

    public OnReset() {

        if (this.chess) {
            this.chess.OnReset()
        }
    }
}