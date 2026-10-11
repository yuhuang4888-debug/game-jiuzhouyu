import { BaseClass } from "../common/BaseClass"
import { BaseVo } from "../common/BaseVo"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { ElimDefine } from "../elim/ElimDefine"
import { ElimGameMgr } from "../elim/ElimGameMgr"
import { SceneManager } from "../scene/SceneManager"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { GuildActivityModel } from "./GuildActivityModel"

export class MiniGameModel extends EventDispatcher {
    public static START_MINI_GAME = "MiniGameModel.START_MINI_GAME"
    public static CLOSE_MINI_GAME = "MiniGameModel.CLOSE_MINI_GAME"
    public static REQUEST_CCMD_EVENT = "MiniGameModel.REQUEST_CCMD_EVENT"
    public static UPDATE_RANK_DATA = "MiniGameModel.UPDATE_RANK_DATA"
    public static REQUEST_PROTO_LIST_39921 = "REQUEST_PROTO_LIST_39921"
    public static CLOSE_RESULT_VIEW = "MiniGameModel.CLOSE_RESULT_VIEW"
    public static GAME_OVER = "MiniGameModel.GAME_OVER"

    public static MiniGameType = {
        Elim: 1,
        RhythmMaster: 2
    }
    static Instance:MiniGameModel
    game_type_
    module_id
    sub_id
    start_time
    is_playing
    test_mode
    end_time
    count_down_func
    game_data
    count_down_id
    rank_data_dic
    is_resume
    Minigamekv
    can_next
    is_end = false
    is_continue=false //是否断线重连
    /**是否正在打开纯客户端版本 */
    is_open_client =false 
    public constructor() {
        super()
        if (MiniGameModel.Instance) {
            return
        }
        MiniGameModel.Instance = this

        //当前小游戏类型
        this.game_type_ = 1
        //当前小游戏的模块ID
        this.module_id = 0
        //当前小游戏的模块子ID
        this.sub_id = 0
        //游戏开始时间
        this.start_time = 0
        //游戏正在进行中
        this.is_playing = false

        this.test_mode = false
    }

    public static GetInstance() {

        if (MiniGameModel.Instance == null) {
            new MiniGameModel()
        }
        return MiniGameModel.Instance
    }
    public InitCfg() {
        this.is_open_client =false
        this.Minigamekv = Config.PRELOAD_SERVER_CONFIG.config_mini_game_kv
    }

    public GetValue(key?) {
        if(!this.Minigamekv){
            this.Minigamekv = Config.PRELOAD_SERVER_CONFIG.config_mini_game_kv
        }
        return this.Minigamekv && this.Minigamekv[key] && this.Minigamekv[key].value
    }

    public StartMiniGame() {
        this.is_playing = true
        this.end_time = this.start_time + this.GetMiniGameTotalTime(this.game_type)
        this.Fire(MiniGameModel.START_MINI_GAME, this.game_type)
        this.StartCountDownTimer()
        
    }

    public StopMiniGame() {

        if (this.IsPlaying()) {
            //this.Fire(MiniGameModel.CLOSE_MINI_GAME, this.game_type) //关闭当前小游戏
        }
        //this.is_playing = false
        this.ClearCountDownTimer()
        //this.count_down_func = false
        //this.game_data = null
    }

    public ElimGameIsFinished() {

        if (this.game_type == MiniGameModel.MiniGameType.Elim && this.end_time) {
            let left_time = this.end_time - TimeUtil.getServerTime()
            if (left_time < 0) {
                return true
            }
        }
        return false
    }

    // /**消消乐阶段剩余时间小于单局消消乐的时间 
    //  * @param e_stage_time 晚宴阶段剩余时间
    // */
    // public CheckEveningStageTimeWithElim(e_stage_time) {
    //     let left_time = this.end_time - TimeUtil.getServerTime()
    //     return e_stage_time>=left_time
    // }

    public StartCountDownTimer() {

        this.ClearCountDownTimer()
        let loop_func, left_time
        loop_func = () => {
            left_time = this.end_time - TimeUtil.getServerTime()
            if (left_time < 0) {
                this.ClearCountDownTimer()
                this.is_end = true
                this.Fire(MiniGameModel.GAME_OVER)
                //this.count_down_func = false
                if (this.test_mode) {
                    //this.Fire(MiniGameModel.REQUEST_CCMD_EVENT, 39931)
                }
                //this.SetBoardData(null)
                return
            }
            if (this.count_down_func) {
                for (let ref in this.count_down_func) {
                    let func = this.count_down_func[ref]
                    func(left_time)
                }
            }
        }
        this.count_down_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
        loop_func()
    }

    public AddCountDownFunc(ref?, func?) {

        if (!this.count_down_func) {
            this.count_down_func = []
        }
        this.count_down_func[ref] = func
    }

    public RemoveCountDownFunc(ref?) {

        if (this.count_down_func && this.count_down_func[ref]) {
            this.count_down_func[ref] = null
        }
    }

    public ClearCountDownTimer() {

        if (this.count_down_id) {
            GlobalTimerQuest.CancelQuest(this.count_down_id)
            this.count_down_id = null
        }
    }

    public SetMiniGameData(scmd?) {
        this.game_type = scmd.game_type
        this.module_id = scmd.module_id
        this.sub_id = scmd.sub_id
        this.start_time = scmd.start_time
        this.game_data = scmd
    }

    public set game_type(value){
        this.game_type_ = value
    }
    public get game_type(){
        return this.game_type_
    }
    public TryStartMiniGame() {
        if (this.GetNowGameOpenCond()) {
            this.StartMiniGame()
        }
    }

    public GetNowGameOpenCond() {

        let bool = true
        if (this.module_id == 402 && this.sub_id == 2) { //公会晚宴小游戏
            bool = SceneManager.GetInstance().IsEveningScene()
            if (this.game_type == MiniGameModel.MiniGameType.Elim && ElimDefine.GMOpen) {
                bool = true
            }
            if (this.game_type == MiniGameModel.MiniGameType.RhythmMaster && this.test_mode) {
                bool = true
            }
        }
        bool = bool && (TimeUtil.getServerTime() - this.start_time < this.GetMiniGameTotalTime(this.game_type))

        return bool
    }

    public GetMiniGameTotalTime(game_type?) {

        if (game_type == MiniGameModel.MiniGameType.RhythmMaster) {
            return this.GetValue(8)||120
        }
        else if (game_type == MiniGameModel.MiniGameType.Elim) {
            return Number(this.GetValue(7))||124
        }
    }

    public IsSameData(scmd?) {

        return this.game_type == scmd.game_type && this.module_id == scmd.module_id && this.sub_id == scmd.sub_id && this.start_time == scmd.start_time
    }

    public SetRankData(scmd?) {

        if (this.rank_data_dic == null) {
            this.rank_data_dic = []
        }

        table.sort(scmd.rank_list, (a?, b?) => {
            return a.rank < b.rank
        })
        this.rank_data_dic[scmd.game_type] = scmd.rank_list
    }

    public GetRankData(game_type?) {

        return this.rank_data_dic && this.rank_data_dic[game_type]
    }

    public IsPlaying() {

        return this.is_playing
    }

    public GetChessBoardLength() {

        let len_str = this.GetValue(10)||"[{8,8}]"
        let len_arr = ErlangParser.GetInstance().parse(len_str)
        if (len_arr) {
            return Number(len_arr[0]), Number(len_arr[1])
        }
        return null
    }

    public SetBoardData(board_data?) {

        this.game_data = board_data
    }

    public SetResumeGame(is_resume?) {

        this.is_resume = is_resume
    }
    public SetWaitState(state) {
        this.can_next = state
    }
    public GetWaitState() {
        return this.can_next
    }
    /**测试时使用 用于更改某个棋子 */
    public TestChangeChess(x, y, buff_type, chess_type?) {
        if (!chess_type) {
            chess_type = 1
        }
        chess_type = buff_type == 4 ? 6 : chess_type //彩蛋强制改成6
        ElimGameMgr.GetInstance().Fire(ElimDefine.ElimEvent.CHANGE_CHESS_BUFF_TYPE, x, y, buff_type, chess_type)
        ElimGameMgr.GetInstance().chess_board.SetChessBuffTest([x, y], buff_type, chess_type)
    }
}

