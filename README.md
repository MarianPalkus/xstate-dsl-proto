[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-Ready--to--Code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/MarianPalkus/xstate-dsl-proto)

# [WIP] xstate-dsl-proto
Experimental dsl for xstate using langium.


# Run VS Code extension

```bash
cd xstate-dsl-proto
npm install
npm run langium:generate
npm run build
```

Run the extension via VS Code launch configuration: Hit `f5` in VS Code.

# Example
An example xstate machine could look like the following:

```
service Service1
cond Cond1
action Action1

initial State01

state State01
state State02 {
    state State02_1

    entry {
        case Cond1 apply Action1
        case default apply Action1
    }
    
    exit {
        case Cond1 apply Action1
    }
    
    on TEST {
        case Cond1  -> State01 
        case default -> State01
    }
}
```