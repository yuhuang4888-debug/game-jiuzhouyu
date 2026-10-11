import { OpenMode } from '../common/BaseView1';
import { BaseWindowComponent } from '../common/BaseWindowComponent';
import { EventName } from '../common/EventName';
import { GhostWalkEvent, GhostWalkModel } from '../commonModel/GhostWalkModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { SentientActEvent, SentientActModel } from '../commonModel/SentientActModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';

export class WorldBattleEnterViewTwo extends BaseWindowComponent {
    goods_model: GoodsModel;
    public constructor() {
        super();
        this.destroy_imm = true;
        this.back_login_toClose = true;
        this.open_mode = OpenMode.OpenOnly;
        this.tabStrList = [{ label: '众生之门' }, { label: '百鬼夜行' }];
        this.viewClassList = ['SentientActMainView', 'GhostWalkView'];
        this.titleList = ['sentientAct.ui_zong_title', 'ghostWalk.ui_bai_title'];
        this.money_list = [2, 1, 0];
        this.bg_list = ['ui_zong_bg.jpg', 'ui_bai_bg.jpg'];
        //this.instruction_list = [InstructionType.TopPk]

        this.window_load_back = () => {
            this.BindEvent(
                SentientActModel.GetInstance(),
                SentientActEvent.UPDATE_COUNT, (assist_num, enter_num) => {
                    this.RefreshSentientActRed()
                }
            )
            this.BindEvent(GhostWalkModel.ins, GhostWalkEvent.RecvFmt20602, () => {
                this.RefreshGhostWalkRed()
            });
            this.RefreshWindowRed();
        };
    }
    public RefreshSentientActRed() {
        let bool = SentientActModel.GetInstance().GetActiveIconRed()
        GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WorldBattleEnterViewTwo", 0, bool)
    }
    public RefreshGhostWalkRed() {
        let bool = GhostWalkModel.ins.getRed()
        GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WorldBattleEnterViewTwo", 1, bool)
    }
    public RefreshWindowRed() {
        this.RefreshSentientActRed()
        this.RefreshGhostWalkRed()
    }

    public Open(...new_args) {
        this.SetIndexParameter(new_args[0]);
        this.SetDefaultIndex(new_args[0]);
        super.Open();
    }
}
window['WorldBattleEnterViewTwo'] = WorldBattleEnterViewTwo;
