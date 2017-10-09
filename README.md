# ZWSlideViewController

[![CI Status](http://img.shields.io/travis/squarezw/ZWSlideViewController.svg?style=flat)](https://travis-ci.org/squarezw/ZWSlideViewController)
[![Version](https://img.shields.io/cocoapods/v/ZWSlideViewController.svg?style=flat)](http://cocoapods.org/pods/ZWSlideViewController)
[![License](https://img.shields.io/cocoapods/l/ZWSlideViewController.svg?style=flat)](http://cocoapods.org/pods/ZWSlideViewController)
[![Platform](https://img.shields.io/cocoapods/p/ZWSlideViewController.svg?style=flat)](http://cocoapods.org/pods/ZWSlideViewController)

`ZWSlideViewController` is a view controller container that manages a customizable sliding views and menus.

## From CocoaPods

ZWSlideViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ZWSlideViewController"
```

## Screenshots

![Screenshot](https://github.com/squarezw/ZWSlideViewController/blob/master/screenshot.gif)


<a href='https://appetize.io/embed/jjm3gvqp5175yeae2n8kdbx0pc' alt='Live demo'>
    <img width="50" height="60" src="demo.png"/>
</a>

## Usage

To show slide page use the following code:

### Step 1

create a class inherits from the ZWSViewController

```
@interface ZWViewController : ZWSViewController

@end
```


### Step 2

implements the required methods

```
- (void)loadData
{
    self.menuTitles = @[@"Drama", @"Family", @"Fantasy", @"Thriller", @"Horror", @"Comedy"];
}

- (UIView *)contentViewForPage:(ZWSPage *)page atIndex:(NSInteger)index
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:page.bounds];

    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kCellIdentifier"];
    tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor colorWithRed:0.5 green:0.1*index blue:0.2*index alpha:1];
    
    return tableView;
}
```

or put any views what you want

```
- (UIView *)contentViewForPage:(ZWSPage *)page atIndex:(NSInteger)index
{
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor colorWithRed:0.5 green:0.1*index blue:0.2*index alpha:1];
    
    return view;
}

```

if you have a asynchronous loading requests data to refresh the slide page, you need invoke following code after requests finish

```
[self refreshViews];

```

you can also put some adjusted style codes here

```
    self.sectionBar.selectedTextColor = [UIColor blueColor];
    self.sectionBar.nomarlTextColor = [UIColor redColor];
    self.sectionBar.backgroundColor = [UIColor blackColor];
    self.menuHeight = 64.0f;
```

Take a look at the Example project to see how to use customization using more




## Author

[@squarezw](https://github.com/squarezw) , [@lamo](https://github.com/Lamod)

## License

ZWSlideViewController is available under the MIT license. See the LICENSE file for more info.
