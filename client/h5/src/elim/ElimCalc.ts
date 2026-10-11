import { BaseClass } from "../common/BaseClass"
import { MiniGameModel } from "../commonModel/MiniGameModel"
import { ErlangParser } from "../util/ErlangParser"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"

/**记分员 */
export class ElimCalc extends BaseClass {
    action_elim_num
    action_score
    extra_score
    game_mgr
    num2score
    total_elim_num
    total_score
    ChessBuffType = ElimDefine.ChessBuffType

    public constructor() {
        super()

        this.extra_score = 0
        this.total_score = 0
        this.action_score = 0
        this.total_elim_num = 0
        this.action_elim_num = 0

        this.game_mgr = ElimGameMgr.GetInstance()
    }

    public GetScoreMapping(elim_num?) {

        if (!this.num2score) {
            this.num2score = []
            let temp_ = "[{3,3},{4,5},{5,6},{6,7},{7,8},{8,9},{9,10},{10,11},{11,12},{12,13}]"
            let score_str = MiniGameModel.GetInstance().GetValue(15)||temp_
            let score_arr = ErlangParser.GetInstance().Parse(score_str)
            if (!score_arr) {
                return elim_num
            }
            for (let _ = 0; _ < score_arr.length; _++) {
                var value = score_arr[_]
                this.num2score[Number(value[0])] = Number(value[1])
            }
        }

        if (this.num2score[elim_num]) {
            return this.num2score[elim_num]
        } else {
            let tmp_score = 0
            for (let num in this.num2score) {
                var score = this.num2score[num]
                if (elim_num > num) {
                    tmp_score = score
                }
            }
            return tmp_score
        }
    }

    public OnBeforeAction() {

        this.action_elim_num = 0
        this.extra_score = 0
        this.action_score = 0
    }

    public OnEliminateChunk(block_list?) {

        if (!block_list) {
            return
        }
        let num = block_list.length
        this.total_elim_num = this.total_elim_num + num
        this.action_elim_num = this.action_elim_num + num

        let score = this.GetScoreMapping(num)
        this.action_score = this.action_score + score + this.extra_score
        let add_score = this.extra_score > 0 ? this.extra_score : score
        this.total_score = this.total_score + add_score
        this.extra_score = 0

        if (num > 0) {
            this.game_mgr.Fire(ElimDefine.ElimEvent.UPDATE_SCORE, this.total_score)
        }
    }

    public SetTotalScore(score?) {

        this.total_score = score
        this.game_mgr.Fire(ElimDefine.ElimEvent.UPDATE_SCORE, this.total_score)
    }

    public OnTriggerBuff(buff?,x?, y?) {
        if (buff.buff_type == this.ChessBuffType.Score) {
            if (buff.value) {
                // 多倍棋子额外分数
                this.extra_score = this.extra_score + buff.value
            }
        }
    }
}