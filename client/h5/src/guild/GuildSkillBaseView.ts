import { BaseWindowComponent } from '../common/BaseWindowComponent';
import { EventName } from '../common/EventName';
import { InstructionType } from '../common/InstructionType';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { MainFunc } from '../commonModel/MainUIModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import './GuildSkillView';

export class GuildSkillBaseView extends BaseWindowComponent {
    model: GuildModel;

    public constructor() {
        super();

        this.model = GuildModel.GetInstance();
        this.dependent_res = ['guild'];
        this.destroy_imm = true;
        this.viewClassList = ['GuildSkillView'];
        this.titleStr = 'guild.guild_001';
        this.money_list = [2, 1, 0];
        this.instruction_list = [null, InstructionType.GuildIdol];
        this.tabStrList = [{ label: '结社技能' }];
        this.preload_server_config = { config_guild_skill_research: false };
        this.bg_list = ['ui_role_bg5.jpg'];

        this.window_load_back = () => {
            this.InitWindowEvent();
        };
    }

    public Open(...new_args) {
        let parms = new_args;
        if (parms && parms[1]) {
            this.SetDefaultIndex(parms[1]);
        }
        super.Open();
    }

    public BaseWindowCloseFunc() {
        GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Guild);
    }
    RefreshSkillRed() {
        let skill_bool = this.model.CheckSkillRedDotAll();
        GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, 'GuildSkillBaseView', 0, skill_bool);
    }

    InitWindowEvent() {
        let guild_model = this.model;
        this.BindEvent(guild_model, GuildEvent.UPDATE_SKILL_RED_STATUS, () => {
            this.RefreshSkillRed();
        });
        this.RefreshSkillRed();
    }
}

window['GuildSkillBaseView'] = GuildSkillBaseView;
