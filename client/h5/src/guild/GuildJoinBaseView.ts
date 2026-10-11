import { BaseWindowComponent } from '../common/BaseWindowComponent';
import { RedKey } from '../common/RedDotDefine';
import './GuildJoinView';

export class GuildJoinBaseView extends BaseWindowComponent {
    bg_list;
    destroy_imm;
    money_list;
    tabStrList;
    titleStr;
    viewClassList;

    public constructor() {
        super();

        this.dependent_res = ['guild'];
        this.destroy_imm = true;
        this.tabStrList = [{ label: '结社', red_key: RedKey.GUILD_APPLY_MARK}];
        this.viewClassList = ['GuildJoinView'];
        this.titleStr = 'guild.guild_001';
        this.money_list = [2, 1, 0];
        this.bg_list = ['uity_086_lashen720x1222.jpg'];
    }
}

window['GuildJoinBaseView'] = GuildJoinBaseView;
