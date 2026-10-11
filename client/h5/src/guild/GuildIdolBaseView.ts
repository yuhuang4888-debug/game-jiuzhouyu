import { BaseWindowComponent } from '../common/BaseWindowComponent';
import { EventName } from '../common/EventName';
import { InstructionType } from '../common/InstructionType';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { MainFunc } from '../commonModel/MainUIModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';

export class GuildIdolBaseView extends BaseWindowComponent {
    dependent_res = ['guild'];
    destroy_imm = true;
    viewClassList = ['GuildIdolMainView'];
    titleStr = 'guild.guild_001';
    money_list = [2, 1, 0];
    instruction_list = [null, InstructionType.GuildIdol];
    tabStrList = [{ label: '结社武魂' }];
    preload_server_config = { config_guild_skill_research: false };
    bg_list = ['uigh_020.jpg'];
    model: GuildModel;

    public constructor() {
        super();

        this.model = GuildModel.GetInstance();
        this.window_load_back = () => {
            this.InitWindowEvent();
        };
    }

    public Open(...new_args) {
        let index = 0
        if (new_args[0]?.length) {
            index = new_args[0]
        }
        this.SetDefaultIndex(index);
        super.Open();
    }

    public BaseWindowCloseFunc() {
        GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Guild);
    }
    
    RefreshIdolRed () {
        let idol_bool = this.model.guildIdolRed();
        GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, 'GuildIdolBaseView', 0, idol_bool);
    };
    InitWindowEvent () {
        let guild_model = this.model;
        this.BindEvent(guild_model, GuildEvent.IDOL_AWAKEN_RED_UPDATE, () => {
            this.RefreshIdolRed();
        });
        this.BindEvent(guild_model, GuildEvent.IDOL_ACT_RED_UPDATE, () => {
            this.RefreshIdolRed();
        });
        this.BindEvent(guild_model, GuildEvent.IDOL_RUNE_RED_UPDATE, () => {
            this.RefreshIdolRed();
        });
        this.RefreshIdolRed();
    };
}

window['GuildIdolBaseView'] = GuildIdolBaseView;
