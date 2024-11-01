# Court Reserve Mobile App - Flutter

## Project
- Flutter version: 3.16.4
- Dart version: 3.2.3
- Architecture: 
  - MVVM
  - RxDart
  - Triple Pattern (UIModel -> handle success, loading, error)
- How to generate files: `dart run build_runner build`

## Presenting the app

### Register | Login | Forgot Password
<p align="middle">
  <img src="/.documentation/Auth_Register.png" width="250" />
  <img src=".documentation/Auth_Login.png" width="250" /> 
  <img src=".documentation/Auth_Forgot_Password.png" width="250" /> 
</p>

### Tennis Courts Search
<p align="middle">
  <img src="/.documentation/Courts_Customer.png" width="400" />
  <img src=".documentation/Courts_Customer_Search.png" width="400" /> 
</p>

* If a user is not logged in and he tires to select a court, a popup is showed.
* If the user is logged in then he can see the details and make a reservation.
<p align="middle">
  <img src="/.documentation/Courts_Select_Not_LoggedIn.png" width="400" />
  <img src="/.documentation/Courts_Tennis_Details_Default.png" width="400" />
</p>

* The user can modify the hours and the price is updated accordingly
<p align="middle">
  <img src="/.documentation/Courts_Tennis_Details_Default.png" width="400" />
  <img src="/.documentation/Courts_Tennis_Details_4Hours.png" width="400" />
</p>

* The user can see pending, current and past reservations
<p align="middle">
  <img src="/.documentation/Courts_TSelectAndReserve.png" width="400" />
  <img src="/.documentation/MyReservations_All.png" width="400" />
</p>



![](.documentation/Courts_TSelectAndReserve.png)
![](.documentation/MyReservations_All.png)
![](.documentation/MyReservations_Options.png)
![](.documentation/MyReservations_Updated.png)
![](.documentation/Profile_LoggedIn.png)
![](.documentation/Profile_LoggedIn_GoldPlan.png)
![](.documentation/Profile_Not_LoggedIn.png)
![](.documentation/TennisCourt_Add.png)
![](.documentation/TennisCourt_Add_Filled.png)
![](.documentation/TennisCourt_Add_MyCourts.png)
![](.documentation/TennisCourt_Add2.png)
![](.documentation/TennisCourt_Add2_MyCourts.png)
![](.documentation/TennisCourt_Edit.png)
![](.documentation/TennisCourt_Edit_NewName.png)
![](.documentation/TennisCourt_ViewReservations.png)
![](.documentation/TennisCourt_ViewReservations_Accept.png)
![](.documentation/TennisCourt_ViewReservations_InPending.png)
![](.documentation/Z_ResetPassword.mp4)